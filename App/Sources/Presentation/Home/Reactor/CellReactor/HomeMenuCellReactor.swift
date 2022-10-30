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


public final class HomeMenuCellReactor: Reactor {
    
    
    public typealias Action = NoAction
    
    
    public struct State {
        var menuType: HomeMenu
    }
    
    public let initialState: State
    
    init(menuType: HomeMenu
    ) {
        defer { _ = self.state }
        self.initialState = State(menuType: menuType)
        print("Menu Type : \(menuType)")
        
    }
    
    
    
}
