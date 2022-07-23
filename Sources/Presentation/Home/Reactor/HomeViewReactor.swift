//
//  HomeViewReactor.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation
import ReactorKit


final class HomeViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case didScroll
        case didEndScroll
    }
    
    enum Mutation {
        case setDidScrollView(Bool)
    }
    
    struct State {
        var isScroll: Bool
    }
    
    init() {
        defer { _ = self.state }
        self.initialState = State(isScroll: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didScroll:
            let didScroll = Observable<Mutation>.just(.setDidScrollView(true))
            return didScroll
        case .didEndScroll:
            let didendScroll = Observable<Mutation>.just(.setDidScrollView(false))
            return didendScroll
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setDidScrollView(isState):
            var newState = state
            newState.isScroll = isState
            return newState
        }
        
    }
    
    
    
}
