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
        case selectSection
        case setProcessProject
    }
    
    enum Mutation {
        case setTransformSetion(Void)
        case setTransformProject(Void)
    }
    
    struct State {
        var isSelectSection: Void?
        var isSelectProject: Void?
    }
    
    init() {
        defer { _ = self.state }
        self.initialState = State(isSelectSection: nil, isSelectProject: nil)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectSection:
            return .just(.setTransformSetion(()))
                .throttle(.seconds(3), scheduler: MainScheduler.instance)
        case .setProcessProject:
            return .just(.setTransformSetion(()))
                .throttle(.seconds(3), scheduler: MainScheduler.instance)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setTransformSetion(action):
            var newState = state
            newState.isSelectSection = action
            return newState
        case let .setTransformProject(action):
            var newState = state
            newState.isSelectProject = action
            return newState
        }
    }
    
    
    
}
