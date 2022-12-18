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
    }
    
    public let initialState: State
    
    init(menuModel: Interest
    ) {
        self.initialState = State(menuModel: menuModel)
        print("Home Menu Data: \(menuModel.imageURL)")
    }
    
    
    
}
