//
//  NoticeViewReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/12/04.
//

import ReactorKit


public final class NoticeViewReactor: Reactor {
    
    public enum Action {
        case viewDidLoad
    }
    
    
    public struct State {
        var isLoading: Bool
    }
    
    
    public enum Mutation {
        case setLoading(Bool)
    }
    
    
    public var initialState: State
    
    public init() {
        defer { _ = self.state }
        self.initialState = State(isLoading: false)
        
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat([startLoading,endLoading])
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
