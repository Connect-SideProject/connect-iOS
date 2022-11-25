//
//  SearchViewSection.swift
//  App
//
//  Created by Kim dohyun on 2022/11/21.
//

import Differentiator

public enum SearchKeywordType: String, Equatable {
    case searchKeyword
}


public enum SearchSection {
    case search([SearchSectionItem])
    
    func getSectionType() -> SearchKeywordType {
        switch self {
        case .search: return .searchKeyword
        }
    }
}

public enum SearchSectionItem {
    case searchList(SearchKeywordCellReactor)
    
}


extension SearchSection: SectionModelType {
    
    public var items: [SearchSectionItem] {
        switch self {
        case let .search(items): return items
        }
    }
    
    public init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .search: self = .search(items)
        }
    }
}
