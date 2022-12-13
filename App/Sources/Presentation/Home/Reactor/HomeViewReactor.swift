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
        case viewWillAppear
        case updateNewItem(String)
    }
    
    public var errorHandler: (Error) -> Observable<Mutation> = { error in
        return .just(.setHomeEmptySection(.homeStudyList([.homeStudyList(HomeStudyListReactor(studyNewsModel: nil, homeNewsRepo: nil, studyNewsId: 0))])))
    }
    
    private let homeRepository: HomeRepository
    private var homeParameter: [String:String?]
    
    public enum Mutation {
        case setLoading(Bool)
        case setHomeMenuItem([HomeMenuList])
        case setHomeNewsItem([HomeStudyList])
        case setHomeEmptySection(HomeViewSection)
        case setReleaseItems([HomeHotList])
        case setSubMenuItems(HomeViewSection)
        case setHomeError(COError?)
        case setSelectMenuType(String)
    }
    
    public struct State {
        var isLoading: Bool
        var isError: COError?
        @Pulse var section: [HomeViewSection]
        @Pulse var releaseSection: [HomeReleaseSection]
        var menuType: String
    }
    
    init(homeRepository: HomeRepository) {
        self.homeParameter = [
            "area": UserManager.shared.profile?.region?.description ?? "",
            "studyType": nil
        ]
        
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
                homeRepository.responseHomeNewsItem(paramenter: homeParameter).catch(errorHandler),
                homeRepository.responseHomeReleaseItem(),
                endLoading
            )
            
        case .viewWillAppear:
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
                homeRepository.responseHomeNewsItem(paramenter: homeParameter).catch(errorHandler),
                homeRepository.responseHomeReleaseItem(),
                endLoading
            )
            
        case let .updateNewItem(menuType):
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            homeParameter.updateValue(menuType, forKey: "studyType")
            
            return .concat(
                startLoading,
                homeRepository.responseHomeNewsItem(paramenter: homeParameter).catch(errorHandler),
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
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
                        
        case let .setHomeMenuItem(items):
            let fieldSectionIndex = self.getIndex(section: .field([]))
            newState.section[fieldSectionIndex] = homeRepository.responseHomeMenuSectionItem(item: items)
            

        case let .setHomeNewsItem(items):
            let studyListIndex = self.getIndex(section: .homeStudyList([]))
            newState.section[studyListIndex] = homeRepository.responseHomeNewsSectionItem(item: items)
            
        case let .setSubMenuItems(items):
            let subMenuIndex = self.getIndex(section: .homeSubMenu([]))
            newState.section[subMenuIndex] = items
            
        case let .setHomeError(error):
            newState.isError = error?.asCOError
                        
        case let.setReleaseItems(items):
            let releaseIndex = self.getReleaseIndex(section: .hotMenu([]))
            newState.releaseSection[releaseIndex] = homeRepository.responseHomeReleaseSectionItem(item: items)
            
        case let .setSelectMenuType(menuType):
            newState.menuType = menuType
            
        case let .setHomeEmptySection(section):
            let emptyIndex = self.getIndex(section: .homeStudyList([]))
            newState.section[emptyIndex] = section
            
        }
        return newState
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
            return .just(.setSelectMenuType(type.currentState.menuType.getTitle()))
        }
    }
    
    func didSelectMenuAction(from event: HomeViewTransform.Event) -> Observable<Action> {
        switch event {
        case let .didSelectHomeMenu(menuType):
            
            return .just(.updateNewItem(StudyType.getStudyType(menuType.currentState.menuType.getTitle())))
        }
        
        
    }
    
}

