//
//  HomeFilterReactor.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/25.
//  Copyright © 2022 sideproj. All rights reserved.
//


import ReactorKit
import UIKit
import CODomain


final class HomeMenuCellReactor: Reactor {
    
    
    typealias Action = NoAction
    
    
    struct State {
        var menuType: HomeMenu
    }
    
    let initialState: State
    
    init(menuType: HomeMenu
    ) {
        defer { _ = self.state }
        self.initialState = State(menuType: menuType)
        print("Menu Type : \(menuType)")
        
    }
    
    
    
}
