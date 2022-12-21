//
//  MapReactor.swift
//  connectUITests
//
//  Created by 이건준 on 2022/07/24.
//  Copyright © 2022 sideproj. All rights reserved.
//

import ReactorKit

import CODomain
import CONetwork

class MapReactor: Reactor {
    
    var disposeBag = DisposeBag()
    private let apiService: ApiService
    
    //Input
    let textObserver: AnyObserver<String>
    
    struct State {
        var isLoading: Bool
        var isEmpty: Bool
        var addressResult: [KakaoMapAddress]?
        var whoMarkerModels: [WhoMarkerModel]?
        var placeStudyInfos: [PlaceStudyInfo]?
        var selectedStudyMarkerLocation: MapCoordinate?
    }
    
    var initialState: State {
        return State(
            isLoading: false,
            isEmpty: true
        )
    }
    
    init(apiService: ApiService = ApiManager.shared) {
        self.apiService = apiService
        let textSubject = PublishSubject<String>()
        textObserver = textSubject.asObserver()
        
        textSubject
            .filter{ $0.count != 0 }
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ Action.searchPlace($0) }
            .bind(to: action)
            .disposed(by: disposeBag)
    }
    
    enum Action {
        /*
         customMarker, customView를 구성하기위한 정보를 받아오기위한 Action
         viewWillAppear할 때마다 새로운 정보를 갱신하기위한 viewDidLoad를 구성
         */
        case viewDidLoad
        case searchPlace(String)
        case tapStudyMarker(Int, MapCoordinate)
        case tapWhoMarker
    }
    
    enum Mutation {
        case getWhoMarkers([WhoMarkerModel])
        case getPlaceStudyInfo([PlaceStudyInfo], MapCoordinate)
        case getWhoMarkerInfos
        case getPlaceInfor([KakaoMapAddress]?)
        case setLoading(Bool)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let studyMardkerInfo = apiService.request(endPoint: .init(path: .getWhoMarker)).map { (data: [WhoMarkerModel]) in
                return data
            }
            return Observable.concat([
                studyMardkerInfo.map{Mutation.getWhoMarkers($0)}.observe(on: MainScheduler.instance)
            ])
        case .searchPlace(let searchQuery):
            let search = ApiManager.shared.requestOutBound(
                endPoint: .init(path: .serchPlace(searchQuery))
            )
                .map { (data: KakaoMapAddresses) -> [KakaoMapAddress] in
                    return data.documents
                }
            
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                search.map{ Mutation.getPlaceInfor($0) }.observe(on: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        case .tapWhoMarker:
            print("????????SDFsdf")
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.getWhoMarkerInfos)
                    .delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        case .tapStudyMarker(let regionID, let location):
            print("tapped = \(regionID)")
            print("tasdfd = \(location)")
            let placeStudyInfo = apiService.request(endPoint: .init(path: .getStudyInfo(regionID)))
                .map { (data: [PlaceStudyInfo])in
                    return data
                }
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                placeStudyInfo.map{ Mutation.getPlaceStudyInfo($0, location) }.observe(on: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getWhoMarkerInfos:
            print("getwhoinfor")
        case .getWhoMarkers(let whoMarkerModels):
            newState.whoMarkerModels = whoMarkerModels
        case .getPlaceStudyInfo(let placeStudyInfos, let location):
            newState.placeStudyInfos = placeStudyInfos
            newState.selectedStudyMarkerLocation = location
        case .getPlaceInfor(let kakaoMapAddresses):
            guard let kakaoMapAddresses = kakaoMapAddresses else { return State(isLoading: false, isEmpty: true, addressResult: []) }
            if !kakaoMapAddresses.isEmpty {
                newState.isEmpty = false
            } else {
                newState.isEmpty = true
            }
            newState.addressResult = kakaoMapAddresses
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
    
}
