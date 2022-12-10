//
//  MeetingDetailController.TableCell.swift
//  Meeting
//
//  Created by Taeyoung Son on 2022/12/10.
//

import UIKit

import COCommonUI
import CODomain
import RxDataSources

extension MeetingDetailController {
    final class CardTableCell: RxBaseTableCell<Any> {
        
    }
    
    final class TextTableCell: RxBaseTableCell<Any> {
        private let titleLabel = UILabel()
        private let descLabel = UILabel()
    }
}

extension MeetingDetailController {
    enum SectionModel: SectionModelType {
        enum Item {
            case card(MeetingInfo), `default`(MeetingInfo)
        }
        
        var items: [Item] {
            switch self {
            case .basic(let items): return items
            }
        }
        
        init(original: SectionModel, items: [Item]) {
            switch original {
            case .basic: self = .basic(items: items)
            }
        }
        
        case basic(items: [Item])
    }
}
