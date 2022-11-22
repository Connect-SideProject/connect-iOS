//
//  SearchDIContainer.swift
//  App
//
//  Created by Kim dohyun on 2022/11/21.
//

import Foundation
import COCommon
import CONetwork



//MARK: Dependency
public final class SearchDependencyContainer: HomeDIContainer {
    
    public typealias HomeReactor = SearchViewReactor
    public typealias HomeViewRepository = SearchViewRepository
    public typealias HomeViewController = SearchViewController
    
    
    private let searchApiService: ApiService
    
    init(searchApiService: ApiService) {
        self.searchApiService = searchApiService
    }
    
    
    public func makeReactor() -> SearchViewReactor {
        return SearchViewReactor()
    }
    
    public func makeRepository() -> HomeViewRepository {
        return SearchViewRepo()
    }
    
    public func makeController() -> SearchViewController {
        return SearchViewController(reactor: makeReactor())
    }
    
    
}


//MARK: Repository
public protocol SearchViewRepository {
    
}



final class SearchViewRepo: SearchViewRepository {

    
}
