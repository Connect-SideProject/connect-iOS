//
//  MyProfilePostListCellReactor.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/12.
//

import Foundation

import ReactorKit
import CODomain


final class MyProfilePostListCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var myStudyModel: ProfileStudy
    }
    
    let initialState: State
    
    init(myStudyModel: ProfileStudy) {
        self.initialState = State(myStudyModel: myStudyModel)
    }
    
    
}
