//
//  ProfileMyPostSection.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/11.
//

import Differentiator



enum ProfileMyPostSection {
    case myProfilePost([ProfileMyPostSectionItem])
}

enum ProfileMyPostSectionItem {
    case myProfilePostItem
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
