//
//  NoticeViewSection.swift
//  App
//
//  Created by Kim dohyun on 2022/12/04.
//

import Differentiator




enum NoticeSection {
    case notice([NoticeSectionItem])
}


enum NoticeSectionItem {
    case noticeItem
}


extension NoticeSection: SectionModelType {
    
    var items: [NoticeSectionItem] {
        switch self {
        case let .notice(items): return items
            
        }
    }
    
    init(original: NoticeSection, items: [NoticeSectionItem]) {
        switch original {
        case .notice: self = .notice(items)
        }
    }
    
}
