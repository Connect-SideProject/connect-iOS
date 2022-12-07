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
        case didTapPostBookMark(String)
    }
    
    public enum Mutation {
        case setPostBookMarkItems(HomeBookMarkList)
    }
    
    private let postListRepo: PostListRepo
    
    public struct State {
        var postModel: PostContentList
        var postBookMarkItems: HomeBookMarkList?
    }
    
    
    public let initialState: State
    
    init(postModel: PostContentList, postListRepo: PostListRepo) {
        defer { _ = self.state }
        self.initialState = State(postModel: postModel, postBookMarkItems: nil)
        self.postListRepo = postListRepo
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didTapPostBookMark(id):
            let postBookMarkMutation = postListRepo.requestPostBookMarkItem(id: id)
            
            return postBookMarkMutation
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setPostBookMarkItems(items):
            var newState = state
            newState.postBookMarkItems = items
            
            print("PostBookMark Item: \(items)")
            
            return newState
        }
    }
    
    
}
