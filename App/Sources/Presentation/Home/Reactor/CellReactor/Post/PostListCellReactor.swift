//
//  PostListCellReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/12/06.
//

import ReactorKit
import CODomain



public final class PostListCellReactor: Reactor {
    
    
    
    public typealias Action = NoAction
    
    
    public struct State {
        var postModel: PostContentList
    }
    
    
    public let initialState: State
    
    init(postModel: PostContentList) {
        defer { _ = self.state }
        self.initialState = State(postModel: postModel)
        print("Post Model: \(postModel)")
    }
    
    
}
