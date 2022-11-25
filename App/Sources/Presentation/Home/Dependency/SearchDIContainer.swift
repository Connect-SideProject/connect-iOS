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
        return SearchViewRepo(searchApiService: self.searchApiService)
    }
    
    public func makeController() -> SearchViewController {
        return SearchViewController(reactor: makeReactor())
    }
    
    
}


//MARK: Repository
public protocol SearchViewRepository {
    func responseSearchKeywordsSectionItem(item: [String]) -> SearchSection
}



final class SearchViewRepo: SearchViewRepository {
    
    //TODO: 추후 All List Server 통신 할 수 있기에 추가
    private let searchApiService: ApiService
    
    public init(searchApiService: ApiService) {
        self.searchApiService = searchApiService
    }
    
    
    func responseSearchKeywordsSectionItem(item: [String]) -> SearchSection {
        var searchRecentlyKeywrodItem: [SearchSectionItem] = []
        
        for i in 0 ..< item.count {
            searchRecentlyKeywrodItem.append(.searchList)
        }
        
        return SearchSection.search(searchRecentlyKeywrodItem)
    }
    

    
}
