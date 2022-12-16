//
//  HomeReleaseCellReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/10/29.
//

import ReactorKit
import CODomain



public final class HomeReleaseCellReactor: Reactor {
    
    
    public typealias Action = NoAction
    
    
    public struct State {
        var releaseModel: HomeHotList
    }
    
    public let initialState: State
    
    init(releaseModel: HomeHotList) {
        defer { _ = self.state }
        self.initialState = State(releaseModel: releaseModel)
        print("Release Model : \(releaseModel)")
    }
    
    
}


