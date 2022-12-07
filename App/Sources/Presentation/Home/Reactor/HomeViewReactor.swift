//
//  HomeViewReactor.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import ReactorKit

import COExtensions
import CONetwork
import CODomain
import COManager


enum HomeViewTransform: TransformType, Equatable {
    enum Event {
        case didSelectHomeMenu(type: HomeStudyMenuReactor)
    }
    case none
}



public final class HomeViewReactor: Reactor, ErrorHandlerable {
        
    public let initialState: State
    
    public enum Action {
        case viewDidLoad
        case updateNewItem(String)
    }
    
    public var errorHandler: (Error) -> Observable<Mutation> = { error in
        return .just(.setHomeError(error.asCOError))
    }
    
    private let homeRepository: HomeRepository
    private var homeParameter: [String:String?]
    
    public enum Mutation {
        case setLoading(Bool)
        case setHomeMenuItem([HomeMenuList])
        case setHomeNewsItem([HomeStudyList])
        case setReleaseItems([HomeHotList])
        case setSubMenuItems(HomeViewSection)
        case setHomeError(COError?)
        case setSelectMenuType(String)
    }
    
    public struct State {
        var isLoading: Bool
        var isError: COError?
        var section: [HomeViewSection]
        var releaseSection: [HomeReleaseSection]
        var menuType: String
    }
    
    init(homeRepository: HomeRepository) {
        self.homeParameter = [
            "area": UserManager.shared.profile?.region?.description ?? "",
            "studyType": nil
        ]
        
        defer { _ = self.state }
        
        self.homeRepository = homeRepository
        
        
        self.initialState = State(
            isLoading: false,
            isError: nil,
            section: [
                .field([]),
                .homeSubMenu([]),
                .homeStudyList([])
            ],
            releaseSection: [
                .hotMenu([])
            ],
            menuType: "전체"
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let setMenuItems = Observable<Mutation>.just(.setSubMenuItems(.homeSubMenu([
                .homeStudyMenu(HomeStudyMenuReactor(menuType: .all, isSelected: true)),
                .homeStudyMenu(HomeStudyMenuReactor(menuType: .project, isSelected: false)),
                .homeStudyMenu(HomeStudyMenuReactor(menuType: .study, isSelected: false))
            ])))
            
                        
            return .concat(
                startLoading,
                homeRepository.responseHomeMenuItem(),
                setMenuItems,
                homeRepository.responseHomeNewsItem(paramenter: homeParameter).catchAndReturn(Mutation.setHomeNewsItem([])),
                homeRepository.responseHomeReleaseItem(),
                endLoading
            )
            
        case let .updateNewItem(menuType):
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            homeParameter.updateValue(menuType, forKey: "studyType")
            
            return .concat(
                startLoading,
                homeRepository.responseHomeNewsItem(paramenter: homeParameter),
                endLoading
            )
        }
    }
    
    public func transform(action: Observable<Action>) -> Observable<Action> {
        let fromHomeMenuAction = HomeViewTransform.event.flatMap { [weak self] event in
            self?.didSelectMenuAction(from: event) ?? .empty()
        }
        
        return Observable.of(action, fromHomeMenuAction).merge()
    }
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromHomeMenuMutation = HomeViewTransform.event.flatMap { [weak self] event in
            self?.didSelectMenuType(from: event) ?? .empty()
        }
        
        return Observable.of(mutation, fromHomeMenuMutation).merge()
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            
            return newState
            
        case let .setHomeMenuItem(items):
            var newState = state
            let fieldSectionIndex = self.getIndex(section: .field([]))
            newState.section[fieldSectionIndex] = homeRepository.responseHomeMenuSectionItem(item: items)
            
            return newState
        case let .setHomeNewsItem(items):
            var newState = state
            let studyListIndex = self.getIndex(section: .homeStudyList([]))
            newState.section[studyListIndex] = homeRepository.responseHomeNewsSectionItem(item: items)
            
            return newState
        case let .setSubMenuItems(items):
            var newState = state
            let subMenuIndex = self.getIndex(section: .homeSubMenu([]))
            newState.section[subMenuIndex] = items
            return newState
            
        case let .setHomeError(error):
            var newState = state
            newState.isError = error?.asCOError
            
            return newState
            
        case let.setReleaseItems(items):
            var newState = state
            let releaseIndex = self.getReleaseIndex(section: .hotMenu([]))
            newState.releaseSection[releaseIndex] = homeRepository.responseHomeReleaseSectionItem(item: items)
            return newState
            
        case let .setSelectMenuType(menuType):
            var newState = state
            newState.menuType = menuType
            
            return newState
        }
        
        
    }
}


private extension HomeViewReactor {
    func getIndex(section: HomeViewSection) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.section.count {
            if self.currentState.section[i].getSectionType() == section.getSectionType() {
                index = i
            }
        }
        return index
    }
    
    func getReleaseIndex(section: HomeReleaseSection) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.releaseSection.count {
            if self.currentState.releaseSection[i].getSectionType() == section.getSectionType() {
                index = i
            }
        }
        return index
    }
    
    func didSelectMenuType(from event: HomeViewTransform.Event) -> Observable<Mutation> {
        switch event {
        case let .didSelectHomeMenu(type):
            print("didSelectMenu Type Home : \(type.currentState.menuType.getTitle())")
            return .just(.setSelectMenuType(type.currentState.menuType.getTitle()))
        }
    }
    
    func didSelectMenuAction(from event: HomeViewTransform.Event) -> Observable<Action> {
        switch event {
        case let .didSelectHomeMenu(menuType):
            print("did SelectMenu Action Type \(menuType.currentState.menuType.getTitle())")
            
            return .just(.updateNewItem(StudyType.getStudyType(menuType.currentState.menuType.getTitle())))
        }
        
        
    }
    
}

