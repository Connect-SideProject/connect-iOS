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
        var menuType: [BottomSheettTitle.sheetModel]
    }
    
    let initialState: State
    
    init(menuType: [BottomSheettTitle.sheetModel]) {
        self.initialState = State(menuType: menuType)
        print("Cell Model : \(menuType.count) or Menu : \(menuType)")
        _ = self.state
    }
    
}
