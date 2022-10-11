//
//  HomeViewReactor.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import ReactorKit



final class HomeViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSubMenuItems(HomeViewSection)
        case setStudyListItems(HomeViewSection)
    }
    
    struct State {
        var isLoading: Bool
        var section: [HomeViewSection]
    }
    
    init() {
        defer { _ = self.state }
        self.initialState = State(
            isLoading: false,
            section: [
                .field([]),
                .homeSubMenu([]),
                .homeStudyList([])
            ]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let setMenuItems = Observable<Mutation>.just(.setSubMenuItems(.homeSubMenu([
                .homeStudyMenu(HomeStudyMenuReactor(menuType: .all)),
                .homeStudyMenu(HomeStudyMenuReactor(menuType: .project)),
                .homeStudyMenu(HomeStudyMenuReactor(menuType: .study))
            ])))
            
            let setStudyListItems = Observable<Mutation>.just(.setStudyListItems(.homeStudyList([
                .homeStudyList,
                .homeStudyList,
                .homeStudyList
            ])))
                        
            return .concat([
                startLoading,setMenuItems,setStudyListItems,endLoading
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            
            return newState

        case let .setSubMenuItems(items):
            var newState = state
            guard let sectionIndex = self.getIndex(section: .homeSubMenu([])) else { return newState }
            newState.section[sectionIndex] = items
            return newState
            
        case let .setStudyListItems(items):
            var newState = state
            guard let sectionIndex = self.getIndex(section: .homeStudyList([])) else { return newState }
            newState.section[sectionIndex] = items
            
            return newState
        }
        
        
    }
}


private extension HomeViewReactor {
    func getIndex(section: HomeViewSection) -> Int? {
        var index: Int? = nil
        
        for i in 0 ..< self.currentState.section.count {
            if self.currentState.section[i].getSectionType() == section.getSectionType() {
                index = i
            }
        }
        return index
    }
}

