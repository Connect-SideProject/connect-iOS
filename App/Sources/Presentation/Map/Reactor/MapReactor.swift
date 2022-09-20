//
//  MapReactor.swift
//  connectUITests
//
//  Created by 이건준 on 2022/07/24.
//  Copyright © 2022 sideproj. All rights reserved.
//

import ReactorKit

import CONetwork

class MapReactor: Reactor {
  
  var disposeBag = DisposeBag()
  
  //Input
  let textObserver: AnyObserver<String>
  
  struct State {
    var isLoading: Bool
    var isEmpty: Bool
    var addressResult: [KakaoMapAddress]
  }
  
  var initialState: State {
    return State(isLoading: false,
                 isEmpty: true,
                 addressResult: [])
  }
  
  init() {
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
    case tapMarker
    case tapCustomView
  }
  
  enum Mutation {
    //Action viewDidLoad
    //        case fetchStudyPositon // 스터디장소가 어디인지
    //        case fetchGuCountView // 해당 구에 대한 개발자인원수를 표시하는 뷰를 표현
    
    case getStudyInfor
    case getWhoInfor
    case getPlaceInfor([KakaoMapAddress]?)
    case setLoading(Bool)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return Observable.concat([
        Observable.just(.getStudyInfor),
        Observable.just(.getWhoInfor)
      ])
    case .searchPlace(let searchQuery):
      let search = ApiManager.shared.requestOutBound(
        endPoint: .init(path: .serchPlace(searchQuery))
      )
      .map { (data: KakaoMapAddresses) -> [KakaoMapAddress] in
        return data.documents
      }
      
//      let searchResult = ApiManager.shared.searchRequest(endPoint: .init(path: .searchPlace(searchQuery)))
//      let searchSuccess = searchResult.map { result -> [KakaoMapAddress]? in
//          guard case .success(let kakaoMapAddresses) = result else { return nil }
//          return kakaoMapAddresses.documents
//      }
      
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        search.map{ Mutation.getPlaceInfor($0) }.observe(on: MainScheduler.instance),
        Observable.just(Mutation.setLoading(false))
      ])
    case .tapCustomView:
      print("????????SDFsdf")
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        Observable.just(Mutation.getWhoInfor)
          .delay(.milliseconds(500), scheduler: MainScheduler.instance),
        Observable.just(Mutation.setLoading(false))
      ])
    case .tapMarker:
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        Observable.just(Mutation.getStudyInfor)
          .delay(.milliseconds(500), scheduler: MainScheduler.instance),
        Observable.just(Mutation.setLoading(false))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .getWhoInfor:
      print("getwhoinfor")
    case .getStudyInfor:
      print("")
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
