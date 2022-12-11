//
//  MeetingDetailController.TableCell.swift
//  Meeting
//
//  Created by Taeyoung Son on 2022/12/10.
//

import UIKit

import RxDataSources
import FlexLayout
import COCommonUI
import CODomain

extension MeetingDetailController {
    final class CardTableCell: RxBaseTableCell<MeetingInfo> {
        private let titleLabel = UILabel()
        private let cardContainer = UIView()
        private let cardTitleArea = UIView()
        private let cardValueArea = UIView()
        private let cardTitleLabels = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
        private let cardValueLabels = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
        
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
                            .marginVertical(20)
                            .define { flex in
                                self.cardTitleLabels.enumerated().forEach {
                                    flex.addItem($1)
                                        .marginTop($0 > 0 ? 12 : 0)
                                }
                            }
                        
                        $0.addItem(self.cardValueArea)
                            .marginLeft(25)
                            .define { flex in
                                self.cardValueLabels.enumerated().forEach {
                                    flex.addItem($1)
                                        .marginTop($0 > 0 ? 12 : 0)
                                }
                            }
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
        
        override func setAttrs() {
            self.contentView.backgroundColor = .hexF9F9F9
            self.setCardContainer()
            self.setLabels()
        }
        
        override func configure(with item: MeetingInfo) {
            
        }
        
        private func setLabels() {
            self.titleLabel.text = "모집정보"
            self.titleLabel.font = .semiBold(size: 16)
            let cardTitles = ["마감일", "모임유형", "진행방식", "분야", "모집인원"]
            self.cardTitleLabels.enumerated().forEach { offset, label in
                label.text = cardTitles[offset]
                label.font = .medium(size: 14)
                label.textColor = .hex8E8E8E
            }
        }
        
        private func setCardContainer() {
            self.cardContainer.layer.backgroundColor = UIColor.white.cgColor
            self.cardContainer.layer.cornerRadius = 16
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
