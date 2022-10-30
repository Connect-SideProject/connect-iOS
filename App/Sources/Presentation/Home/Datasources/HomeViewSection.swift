//
//  HomeViewSection.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/07/25.
//  Copyright © 2022 sideproj. All rights reserved.
//

import RxDataSources


enum HomeListType: String, Equatable {
    case homeMenu
    case homeStudyMenu
    case homeStudyList
}

enum HomeReleaseType: String, Equatable {
    case hotMenu
}

enum HomeReleaseSection {
    case hotMenu([HomeRelaseSectionItem])
    
    func getSectionType() -> HomeReleaseType {
        switch self {
        case .hotMenu: return .hotMenu
        }
    }
}

enum HomeRelaseSectionItem {
    case hotList(HomeReleaseCellReactor)
}

extension HomeReleaseSection: SectionModelType {
    
    var items: [HomeRelaseSectionItem] {
        switch self {
        case let .hotMenu(items): return items
        }
    }
    
    init(original: HomeReleaseSection, items: [HomeRelaseSectionItem]) {
        switch original {
        case .hotMenu: self = .hotMenu(items)
        }
    }
    
}


enum HomeViewSection {
    case field([HomeViewSectionItem])
    case homeSubMenu([HomeViewSectionItem])
    case homeStudyList([HomeViewSectionItem])
    
    func getSectionType() -> HomeListType {
        switch self {
        case .field: return .homeMenu
        case .homeSubMenu: return .homeStudyMenu
        case .homeStudyList: return .homeStudyList
        }
    }
}

extension HomeViewSection: SectionModelType {
    
    var items: [HomeViewSectionItem] {
        switch self {
        case let .field(items): return items
        case let .homeSubMenu(items): return items
        case let .homeStudyList(items): return items
        }
        
    }
    
    init(original: HomeViewSection, items: [HomeViewSectionItem]) {
        switch original {
        case .field: self = .field(items)
        case .homeSubMenu: self = .homeSubMenu(items)
        case .homeStudyList: self = .homeStudyList(items)
        }
    }
    
}


enum HomeViewSectionItem {
    case homeMenu(HomeMenuCellReactor)
    case homeStudyMenu(HomeStudyMenuReactor)
    case homeStudyList
}
