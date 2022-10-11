//
//  BottomSheetCellReactor.swift
//  connect
//
//  Created by Kim dohyun on 2022/08/30.
//

import ReactorKit


final class BottomSheetCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var menuType: String
    }
    
    let initialState: State
    
    init(menuType: String) {
        self.initialState = State(menuType: menuType)
        print("Cell Model : \(menuType) or Menu : \(menuType)")
        _ = self.state
    }
    
}
