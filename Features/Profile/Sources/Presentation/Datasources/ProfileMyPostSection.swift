//
//  ProfileMyPostSection.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/11.
//

import Differentiator


enum ProfileMyPostType: String, Equatable {
    case myStudy
    case myBookMark
}


public enum ProfileMyPostSection {
    case myProfilePost([ProfileMyPostSectionItem])
    case myProfileBookMark([ProfileMyPostSectionItem])
    
    func getSectionType() -> ProfilePostType {
        switch self {
        case .myProfilePost: return .study
        case .myProfileBookMark: return .bookMark
        }
    }
}

public enum ProfileMyPostSectionItem {
    case myProfilePostItem(MyProfilePostListCellReactor)
    case myProfileBookMarkItem(MyProfileBookMarkListCellReactor)
}


extension ProfileMyPostSection: SectionModelType {
    
    public var items: [ProfileMyPostSectionItem] {
        switch self {
        case let .myProfilePost(items): return items
        case let .myProfileBookMark(items): return items
        }
    }
    
    public init(original: ProfileMyPostSection, items: [ProfileMyPostSectionItem]) {
        switch original {
        case .myProfilePost: self = .myProfilePost(items)
        case .myProfileBookMark: self = .myProfileBookMark(items)
        }
    }
    
}
