//
//  HomeReleaseCellReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/10/29.
//

import ReactorKit
import CODomain



public final class HomeReleaseCellReactor: Reactor {
    
    
    public enum Action {
        case didTapBookMarkButton
    }
    
    public enum Mutation {
        case updateSelected(Bool)
    }
    
    
    public struct State {
        var releaseModel: HomeHotList
        var isSelected: Bool
    }
    
    public let initialState: State
    
    init(releaseModel: HomeHotList) {
        defer { _ = self.state }
        self.initialState = State(releaseModel: releaseModel, isSelected: false)
        print("Release Model : \(releaseModel)")
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBookMarkButton:
            let updateSelectBookMark = Observable<Mutation>.just(.updateSelected(!self.currentState.isSelected))
            
            return .concat(updateSelectBookMark)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .updateSelected(isSelected):
            var newState = state
            newState.isSelected = isSelected
            
            return newState
        }
    }
    
    
}


