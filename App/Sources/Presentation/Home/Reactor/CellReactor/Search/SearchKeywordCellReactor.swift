//
//  SearchKeywordCellReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/11/25.
//

import ReactorKit


public final class SearchKeywordCellReactor: Reactor {
    
    
    public typealias Action = NoAction
    
    
    public struct State {
        var keywordItems: String
    }
    
    public var initialState: State
    
    
    public init(keywordItems: String) {
        defer { _ = self.state }
        self.initialState = State(keywordItems: keywordItems)
    }
    
    
}


