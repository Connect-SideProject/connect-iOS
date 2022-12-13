//
//  PostListCellReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/12/06.
//

import ReactorKit
import CODomain



public final class PostListCellReactor: Reactor {
    
    
    
    public enum Action {
        case didTapPostBookMark
    }
    
    public enum Mutation {
        case setPostBookMarkItems(HomeBookMarkList)
    }
    
    private let postListRepo: PostListRepo
    
    public struct State {
        var postModel: PostContentList
        var postBookMarkItems: HomeBookMarkList?
        var postListId: Int
    }
    
    
    public let initialState: State
    
    init(postModel: PostContentList, postListRepo: PostListRepo, postListId: Int) {
        self.initialState = State(postModel: postModel, postBookMarkItems: nil, postListId: postListId)
        self.postListRepo = postListRepo
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapPostBookMark:
            let postBookMarkMutation = postListRepo.requestPostBookMarkItem(id: String(self.currentState.postListId))
            
            return postBookMarkMutation
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setPostBookMarkItems(items):
            newState.postBookMarkItems = items
        }
        
        return newState
    }
    
    
}
