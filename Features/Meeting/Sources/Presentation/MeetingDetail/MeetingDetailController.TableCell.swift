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
    
    typealias TextKeyValuePair = (title: String, description: String)
    
    final class CardTableCell: RxBaseTableCell<MeetingInfo> {
        private let titleLabel = UILabel()
        private let cardContainer = UIView()
        private let cardTitleArea = UIView()
        private let cardValueArea = UIView()
        private let cardTitleLabels = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
        private let cardValueLabels = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
        private let dDayLabel = UILabel()
        
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
                            .marginVertical(20)
                            .define { flex in
                                self.cardValueLabels.enumerated().forEach { offset, label in
                                    if offset > 0 {
                                        flex.addItem(label)
                                            .marginTop(12)
                                    } else {
                                        flex.addItem()
                                            .direction(.row)
                                            .define { flex in
                                                flex.addItem(label)
                                                flex.addItem(self.dDayLabel)
                                                    .marginLeft(10)
                                            }
                                    }
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
            self.selectionStyle = .none
            self.contentView.backgroundColor = .hexF9F9F9
            self.setCardContainer()
            self.setLabels()
        }
        
        override func configure(with item: MeetingInfo) {
            let values = [item.endDate.toDate(format: "yyyy-MM-dd")?.toFormattedString(dateFormat: "yy.MM.dd") ?? "",
                          item.studyType,
                          item.meetingType,
                          item.categories.map(\.category).joined(separator: " ,"),
                          item.parts.map(\.description).joined(separator: " ,")]
            self.cardValueLabels.enumerated().forEach { offset, label in
                label.text = values[offset]
            }
            self.dDayLabel.text = item.endDate.toDate(format: "yyyy-MM-dd")?.toDdayFormattedStr()
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
            self.cardValueLabels.forEach {
                $0.font = .medium(size: 14)
                $0.textColor = .black
            }
            self.dDayLabel.font = .medium(size: 14)
            self.dDayLabel.textColor = .hex06C755
        }
        
        private func setCardContainer() {
            self.cardContainer.layer.backgroundColor = UIColor.white.cgColor
            self.cardContainer.layer.cornerRadius = 16
        }
    }
    
    final class TextTableCell: RxBaseTableCell<TextKeyValuePair> {
        private let titleLabel = UILabel()
        private let descLabel = UILabel()
        
        override func setupContainer() {
            self.contentView.flex.define {
                $0.addItem(self.titleLabel)
                    .marginTop(16)
                    .marginLeft(20)
                
                $0.addItem(self.descLabel)
                    .marginTop(12)
                    .marginHorizontal(20)
                    .marginBottom(14)
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
        
        override func configure(with item: TextKeyValuePair) {
            self.titleLabel.text = item.title
            self.descLabel.text = item.description
        }
        
        override func setAttrs() {
            super.setAttrs()
            self.selectionStyle = .none
            self.titleLabel.font = .semiBold(size: 16)
            self.descLabel.font = .medium(size: 14)
            self.descLabel.numberOfLines = 0
        }
    }
}

extension MeetingDetailController {
    enum SectionModel: SectionModelType {
        enum Item {
            case card(MeetingInfo), `default`(TextKeyValuePair)
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
