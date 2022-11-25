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
        var menuType: HomeMenuList
        var homeCellRepo: HomeViewRepo
    }
    
    public let initialState: State
    
    init(menuType: HomeMenuList,
         homeCellRepo: HomeViewRepo
    ) {
        defer { _ = self.state }
        self.initialState = State(menuType: menuType, homeCellRepo: homeCellRepo)
        print("Menu Type : \(menuType)")
        
    }
    
    
    
}
