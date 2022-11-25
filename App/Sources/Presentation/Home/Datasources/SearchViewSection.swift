//
//  SearchViewSection.swift
//  App
//
//  Created by Kim dohyun on 2022/11/21.
//

import Differentiator


public enum SearchSection {
    case search([SearchSectionItem])
}

public enum SearchSectionItem {
    case searchList
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
