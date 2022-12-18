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
        var menuModel: Interest
        var menuRepo: HomeRepository
    }
    
    public let initialState: State
    
    init(menuModel: Interest, menuRepo: HomeRepository
    ) {
        self.initialState = State(menuModel: menuModel, menuRepo: menuRepo)
    }
    
    
    
}
