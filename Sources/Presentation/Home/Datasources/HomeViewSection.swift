//
//  HomeViewSection.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/07/25.
//  Copyright © 2022 sideproj. All rights reserved.
//

import RxDataSources



enum HomeViewSection {
    case field([HomeViewSectionItem])
    
    func getSectionType() -> HomeSectionType {
        switch self {
        case .field: return .field
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
    case commerce(HomeMenuCellReactor)
    case finance(HomeMenuCellReactor)
    case health(HomeMenuCellReactor)
    case travel(HomeMenuCellReactor)
}
