//
//  MapViewReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/12/30.
//

import ReactorKit



public final class MapViewReactor: Reactor {
    
    public var initialState: State
    private let mapRepository: MapRepository
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
    }
    
    public struct State {
        var isLoading: Bool
    }
    
    
    public init(mapRepository: MapRepository) {
        self.initialState = State(isLoading: false)
        self.mapRepository = mapRepository
    }
    
    
    
    
}

