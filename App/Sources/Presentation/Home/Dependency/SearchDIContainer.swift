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
    public typealias HomeViewRepository = SearchRepository
    public typealias HomeViewController = SearchController
    
    
    private let searchApiService: ApiService
    
    init(searchApiService: ApiService) {
        self.searchApiService = searchApiService
    }
    
    
    public func makeReactor() -> SearchViewReactor {
        return SearchViewReactor(searchRepository: makeRepository())
    }
    
    public func makeRepository() -> HomeViewRepository {
        return SearchViewRepo(searchApiService: self.searchApiService)
    }
    
    public func makeController() -> SearchController {
        return SearchController(reactor: makeReactor())
    }
    
    
}


//MARK: Repository
public protocol SearchRepository {
    func responseSearchKeywordsSectionItem() -> SearchSection
}



final class SearchViewRepo: SearchRepository {
    
    //TODO: 추후 All List Server 통신 할 수 있기에 추가
    private let searchApiService: ApiService
    
    public init(searchApiService: ApiService) {
        self.searchApiService = searchApiService
    }
    
    
    func responseSearchKeywordsSectionItem() -> SearchSection {
        var searchRecentlyKeywordItem: [SearchSectionItem] = []
        var recentlyKeyWordItems = UserDefaults.standard.stringArray(forKey: .recentlyKeywords)
        print("Userdefault DI: \(UserDefaults.standard.stringArray(forKey: .recentlyKeywords))")
        
        for i in 0 ..< recentlyKeyWordItems.count {
            searchRecentlyKeywordItem.append(.searchList(SearchKeywordCellReactor(keywordItems: recentlyKeyWordItems[i], indexPath: i)))
        }
        
        return SearchSection.search(searchRecentlyKeywordItem)
    }
    

    
}
