//
//  PostViewSection.swift
//  App
//
//  Created by Kim dohyun on 2022/11/13.
//

import Differentiator


public enum PostListType: String, Equatable {
    case postAll
}


public enum PostViewSection {
    case post([PostSectionItem])
    
    func getSectionType() -> PostListType {
        switch self {
        case .post: return .postAll
        }
    }
}

public enum PostSectionItem {
    case postList(PostListCellReactor)
}

extension PostViewSection: SectionModelType {
    
    public var items: [PostSectionItem] {
        switch self {
        case let .post(items): return items
            
        }
    }
    
    public init(original: PostViewSection, items: [PostSectionItem]) {
        switch original {
        case .post: self = .post(items)
            
        }
    }
    
}
