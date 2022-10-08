//
//  MapFloatingReactor.swift
//  connect
//
//  Created by 이건준 on 2022/08/16.
//  Copyright © 2022 sideproj. All rights reserved.
//

import ReactorKit

import CODomain

class MapFloatingReactor: Reactor {
    
    var initialState: State = State(string: "")
    
    struct State {
        var string: String
    }
    
    enum Action {
        case practice([KakaoMapAddress])
    }
    
    enum Mutation {
        case practiceMutation
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .practice:
            return Observable.just(Mutation.practiceMutation)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .practiceMutation:
            newState.string = "성공??"
        }
        return newState
    }
}
