//
//  BottomSheetCellReactor.swift
//  connect
//
//  Created by Kim dohyun on 2022/08/30.
//

import ReactorKit


final class BottomSheetCellReactor<T>: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var menuType: T
    }
    
    let initialState: State
    
    init(menuType: T) {
        self.initialState = State(menuType: menuType)
        _ = self.state
    }
    
}
