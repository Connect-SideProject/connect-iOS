//
//  MapDIContainer.swift
//  App
//
//  Created by Kim dohyun on 2022/12/30.
//

import Foundation

import COCommon
import CONetwork

//MARK: Dependency
public final class MapDependencyContainer: MapDIContainer {
    public typealias Reactor = MapViewReactor
    public typealias Repository = MapRepository
    public typealias Controller = MapViewController
    
    private let mapApiService: ApiService
    
    public init(mapApiService: ApiService) {
        self.mapApiService = mapApiService
    }
    
    public func makeRepository() -> Repository {
        return MapViewRepo()
    }
    
    public func makeReactor() -> MapViewReactor {
        return MapViewReactor(mapRepository: makeRepository())
    }
    
    public func makeController() -> MapViewController {
        return MapViewController(reactor: makeReactor())
    }
    
    
    
    
    
}


public protocol MapRepository {
    func responseLocationMarker()
}


final class MapViewRepo: MapRepository {
    
    private let mapApiService: ApiService
    
    public init(mapApiService: ApiService = ApiManager.shared) {
        self.mapApiService = mapApiService
    }
    
    //TODO: API Network Code 추가
    func responseLocationMarker() {
        
    }
    
    
}
