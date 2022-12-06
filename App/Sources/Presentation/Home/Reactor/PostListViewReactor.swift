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
        case didTapInterestSheet(text: String)
        case responseSheetItem(item: [BottomSheetItem])
    }

    case none
}

public final class PostListViewReactor: Reactor, ErrorHandlerable {
    
    public enum Action {
        case viewDidLoad
    }
    
    public struct State {
        var isLoading: Bool
        var isError: COError?
        var bottomSheetItem: [BottomSheetItem]
        var section: [PostViewSection]
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPostError(COError?)
        case setPostSheetItem([String])
        case setPostListItem(PostAllList)
    }
    
    public var initialState: State
    private let postRepository: PostListRepository
    
    public var errorHandler: (Error) -> Observable<Mutation> = { error in
        return .just(.setPostError(error.asCOError))
    }
    
    init(postRepository: PostListRepository) {
        defer { _ = self.state }
        self.postRepository = postRepository
        self.initialState = State(
            isLoading: false,
            bottomSheetItem: [],
            section: [
                .post([])
            ]
        )
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            
            return .concat(
                startLoading,
                postRepository.responsePostListItem(parameter: nil),
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
        case let .setPostListItem(items):
            var newState = state
            let postAllIndex = self.getIndex(section: .post([]))
            print("Post All List Items: \(items)")
            newState.section[postAllIndex] = postRepository.responsePostListSectionItem(item: items.postList)
            return newState
        }
    }
    
}



private extension PostListViewReactor {
    func getIndex(section: PostViewSection) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.section.count {
            if self.currentState.section[i].getSectionType() == section.getSectionType() {
                index = i
            }
        }
        
        return index
    }
    
    
}
