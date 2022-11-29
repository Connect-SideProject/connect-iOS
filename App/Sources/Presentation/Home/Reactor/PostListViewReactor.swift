//
//  PostListViewReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/11/13.
//

import ReactorKit
import RxCocoa

import COExtensions
import CONetwork
import COCommonUI


public enum PostFilterTransform: TransformType, Equatable {
    enum Event {
        case didTapOnOffLineSheet(text: String, completion: (() -> Void)?)
        case didTapAligmentSheet(text: String)
        case didTapStudyTypeSheet(text: String)
    }

    case none
}

public final class PostListReactor: Reactor, ErrorHandlerable {
    
    public enum Action {
        case viewDidLoad
    }
    
    public struct State {
        var isLoading: Bool
        var isError: COError?
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPostError(COError?)
    }
    
    public var initialState: State
    
    
    public var errorHandler: (Error) -> Observable<Mutation> = { error in
        return .just(.setPostError(error.asCOError))
    }
    
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
            
        case let .setPostError(isError):
            var newState = state
            newState.isError = isError
            
            return newState
        }
    }
    
}
