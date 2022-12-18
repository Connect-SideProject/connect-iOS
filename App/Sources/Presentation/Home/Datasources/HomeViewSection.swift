//
//  HomeViewSection.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/07/25.
//  Copyright © 2022 sideproj. All rights reserved.
//

import RxDataSources


public enum HomeListType: String, Equatable {
    case homeMenu
    case homeStudyMenu
    case homeStudyList
}

public enum HomeReleaseType: String, Equatable {
    case hotList
}

public enum HomeReleaseSection {
    case hotMenu([HomeRelaseSectionItem])
    
    func getSectionType() -> HomeReleaseType {
        switch self {
        case .hotMenu: return .hotList
        }
    }
}

public enum HomeRelaseSectionItem {
    case hotList(HomeReleaseCellReactor)
}

extension HomeReleaseSection: SectionModelType {
    
    public var items: [HomeRelaseSectionItem] {
        switch self {
        case let .hotMenu(items): return items
        }
    }
    
    public init(original: HomeReleaseSection, items: [HomeRelaseSectionItem]) {
        switch original {
        case .hotMenu: self = .hotMenu(items)
        }
    }
    
}


public enum HomeViewSection {
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
    
    public var items: [HomeViewSectionItem] {
        switch self {
        case let .field(items): return items
        case let .homeSubMenu(items): return items
        case let .homeStudyList(items): return items
        }
        
    }
    
    public init(original: HomeViewSection, items: [HomeViewSectionItem]) {
        switch original {
        case .field: self = .field(items)
        case .homeSubMenu: self = .homeSubMenu(items)
        case .homeStudyList: self = .homeStudyList(items)
        }
    }
    
}


public enum HomeViewSectionItem {
    case homeMenu(HomeMenuCellReactor)
    case homeStudyMenu(HomeStudyMenuReactor)
    case homeStudyList(HomeStudyListReactor)
}
