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
        var indexPath: Int
    }
    
    public var initialState: State
    
    
    public init(keywordItems: String, indexPath: Int) {
        self.initialState = State(keywordItems: keywordItems, indexPath: indexPath)
    }
    
    
}


