//
//  SearchViewReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/11/22.
//

import ReactorKit



public final class SearchViewReactor: Reactor {

    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
    }
    
    public struct State {
        var isLoading: Bool
    }
    
    public var initialState: State
    
    init() {
        defer { _ = self.state }
        self.initialState = State(isLoading: false)
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(startLoading,endLoading)
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            
            return newState
        }
    }
    
    
}
