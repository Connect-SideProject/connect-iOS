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


enum ProfileMyPostSection {
    case myProfilePost([ProfileMyPostSectionItem])
    
    func getSectionType() -> ProfilePostType {
        switch self {
        case .myProfilePost: return .study
        }
    }
}

enum ProfileMyPostSectionItem {
    case myProfilePostItem(MyProfilePostListCellReactor)
}


extension ProfileMyPostSection: SectionModelType {
    
    var items: [ProfileMyPostSectionItem] {
        switch self {
        case let .myProfilePost(items): return items
        }
    }
    
    init(original: ProfileMyPostSection, items: [ProfileMyPostSectionItem]) {
        switch original {
        case .myProfilePost: self = .myProfilePost(items)
        }
    }
    
}
