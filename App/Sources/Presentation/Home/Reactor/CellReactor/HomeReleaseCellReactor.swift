//
//  HomeReleaseCellReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/10/29.
//

import ReactorKit
import CODomain



final class HomeReleaseCellReactor: Reactor {
    
    
    typealias Action = NoAction
    
    
    struct State {
        var releaseModel: HomeHotList
    }
    
    let initialState: State
    
    init(releaseModel: HomeHotList) {
        defer { _ = self.state }
        self.initialState = State(releaseModel: releaseModel)
        print("Release Model : \(releaseModel)")
    }
    
    
}


