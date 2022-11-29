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
import CODomain


public enum PostFilterTransform: TransformType, Equatable {
    enum Event {
        case didTapOnOffLineSheet(text: String, completion: (() -> Void)?)
        case didTapAligmentSheet(text: String)
        case didTapStudyTypeSheet(text: String)
        case responseSheetItem(item: [BottomSheetItem])
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
        var bottomSheetItem: [BottomSheetItem]
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPostError(COError?)
        case setPostSheetItem([String])
    }
    
    public var initialState: State
    private let postRepository: PostListRepository
    
    public var errorHandler: (Error) -> Observable<Mutation> = { error in
        return .just(.setPostError(error.asCOError))
    }
    
    init(postRepository: PostListRepository) {
        defer { _ = self.state }
        self.postRepository = postRepository
        self.initialState = State(isLoading: false, bottomSheetItem: [])
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(
                startLoading,
                postRepository.responsePostSheetItem(),
                endLoading
            )
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
            
        case let .setPostSheetItem(items):
            var newState = state
            var bottomSheetItems: [BottomSheetItem] = []
            _ = items.map { item in
                bottomSheetItems.append(BottomSheetItem(value: item))
            }
            newState.bottomSheetItem = bottomSheetItems
            print("set Bottom Sheet Item: \(items)")
            return newState
        }
    }
    
}
