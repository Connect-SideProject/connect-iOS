//
//  MeetingDetailController.TableCell.swift
//  Meeting
//
//  Created by Taeyoung Son on 2022/12/10.
//

import UIKit

import FlexLayout
import COCommonUI
import CODomain
import RxDataSources

extension MeetingDetailController {
    final class CardTableCell: RxBaseTableCell<Any> {
        private let titleLabel = UILabel()
        private let cardContainer = UIView()
        private let cardTitleArea = VStackView()
        private let cardValueArea = VStackView()
        
        override func setupContainer() {
            self.contentView.flex.define {
                $0.addItem(self.titleLabel)
                    .marginTop(22)
                    .marginLeft(20)
                
                $0.addItem(self.cardContainer)
                    .marginTop(15)
                    .marginHorizontal(20)
                    .marginBottom(35)
                    .direction(.row)
                    .define {
                        $0.addItem(self.cardTitleArea)
                            .minWidth(17)
                            .marginLeft(25)
                        
                        $0.addItem(self.cardValueArea)
                            .marginLeft(25)
                    }
            }
        }
        
        public override func layout() {
            self.contentView.flex.layout(mode: .adjustHeight)
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            self.contentView.pin.width(size.width)
            self.layout()
            return self.contentView.frame.size
        }
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
