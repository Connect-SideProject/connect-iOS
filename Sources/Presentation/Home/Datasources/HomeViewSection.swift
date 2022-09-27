//
//  HomeViewSection.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/07/25.
//  Copyright © 2022 sideproj. All rights reserved.
//

import RxDataSources

enum HomeListType: String, Equatable {
    case commerce
    case finance
    case health
    case travel
}


enum HomeViewSection {
    case field([HomeViewSectionItem])

    public func getSectionType() -> HomeListType {
        switch self {
        case .field: return .commerce
        }
    }
}

extension HomeViewSection: SectionModelType {
    
    var items: [HomeViewSectionItem] {
        switch self {
        case let .field(items): return items
        }
    }
    
    init(original: HomeViewSection, items: [HomeViewSectionItem]) {
        switch original {
        case .field: self = .field(items)
        }
    }
    
}


enum HomeViewSectionItem {
    case homeMenu(HomeMenuCellReactor)
    case homeStudyMenu
}
