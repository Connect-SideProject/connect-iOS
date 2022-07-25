//
//  HomeViewSection.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/07/25.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import RxDataSources


enum HomeViewSection {
    case filter([HomeViewSectionItem])
    case location([HomeViewSectionItem])
    case field([HomeViewSectionItem])
    case realTime([HomeViewSectionItem])
    case user([HomeViewSectionItem])
}

extension HomeViewSection: SectionModelType {
    
    var items: [HomeViewSectionItem] {
        switch self {
        case let .filter(items): return items
        case let .location(items): return items
        case let .field(items): return items
        case let .realTime(items): return items
        case let .user(items): return items
        }
    }
    
    init(original: HomeViewSection, items: [HomeViewSectionItem]) {
        switch original {
        case .filter: self = .filter(items)
        case .location: self = .location(items)
        case .field: self = .field(items)
        case .realTime: self = .realTime(items)
        case .user: self = .user(items)
        }
    }
    
}


enum HomeViewSectionItem {
    case filter
    case location
    case field
    case realTime
    case user
}
