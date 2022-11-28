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
        case didTapOnOffLineSheet(text: String, type: BottomSheetType)
        case didTapAligmentSheet(type: String)
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
        var onOffLineType: String
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPostError(COError?)
        case setOnOffLineFilter(String, BottomSheetType)
    }
    
    public var initialState: State
    
    
    public var errorHandler: (Error) -> Observable<Mutation> = { error in
        return .just(.setPostError(error.asCOError))
    }
    
    init() {
        defer { _ = self.state }
        self.initialState = State(isLoading: false, onOffLineType: "전체")
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(startLoading,endLoading)
        }
    }
    
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let fromSheetTypeMutation = PostFilterTransform.event.flatMap { [weak self] event in
            self?.didTapBottomSheetTransform(from: event) ?? .empty()
        }
    
        return Observable.of(mutation, fromSheetTypeMutation).merge()
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
            
        case let .setOnOffLineFilter(onOffLineType, SheetType):
            var newState = state
            newState.onOffLineType = onOffLineType
            
            return newState
        }
    }
    
}



private extension PostListReactor {
    func didTapBottomSheetTransform(from event: PostFilterTransform.Event) -> Observable<Mutation> {
        
        switch event {
        case let .didTapOnOffLineSheet(text, type):
            return .just(.setOnOffLineFilter(text, type))
        default:
            return .empty()
        }
    }
    
}
