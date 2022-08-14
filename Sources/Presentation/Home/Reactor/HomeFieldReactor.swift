//
//  HomeFilterReactor.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/25.
//  Copyright © 2022 sideproj. All rights reserved.
//

import ReactorKit


final class HomeFieldReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case didSelectSearchView
    }
    
    enum Mutation {
        case willAppearSearchView(Void)
    }
    
    struct State {
        var isLoading: Bool
    }
    
    
    init() {
        defer { _ = self.state }
        self.initialState = State(isLoading: false)
    }
    
    
    
}
