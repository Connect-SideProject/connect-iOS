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
        case setFieldItemList(HomeViewSection)
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
                .field([])
            ]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let setLoadCollectionView = Observable<Mutation>.just(.setFieldItemList(.field([
                .homeMenu(HomeMenuCellReactor(menuType: .travelmenu)),
                .homeMenu(HomeMenuCellReactor(menuType: .financemenu)),
                .homeMenu(HomeMenuCellReactor(menuType: .commercemenu)),
                .homeMenu(HomeMenuCellReactor(menuType: .healthmenu))
            ])))

            return .concat(
                .just(.setLoading(true)),
                setLoadCollectionView,
                .just(.setLoading(false))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            
            return newState
        case let .setFieldItemList(items):
            var newState = state
            guard let sectionIndex = self.getIndex(section: .field([])) else { return newState }
            newState.section[sectionIndex] = items
            print("Items value: \(items) or new Section \(newState.section)")
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
