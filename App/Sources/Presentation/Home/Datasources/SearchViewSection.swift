//
//  SearchViewSection.swift
//  App
//
//  Created by Kim dohyun on 2022/11/21.
//

import Differentiator


enum SearchSection {
    case search([SearchSectionItem])
}

enum SearchSectionItem {
    case searchList
}


extension SearchSection: SectionModelType {
    
    var items: [SearchSectionItem] {
        switch self {
        case let .search(items): return items
        }
    }
    
    init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .search: self = .search(items)
        }
    }
}
