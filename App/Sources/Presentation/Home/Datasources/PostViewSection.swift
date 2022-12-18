//
//  PostViewSection.swift
//  App
//
//  Created by Kim dohyun on 2022/11/13.
//

import Differentiator



enum PostSection {
    case post([PostSectionItem])
}

enum PostSectionItem {
    case postList
}

extension PostSection: SectionModelType {
    
    var items: [PostSectionItem] {
        switch self {
        case let .post(items): return items
            
        }
    }
    
    init(original: PostSection, items: [PostSectionItem]) {
        switch original {
        case .post: self = .post(items)
            
        }
    }
    
}
