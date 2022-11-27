//
//  ChatListController.TableCell.swift
//  Chat
//
//  Created by Taeyoung Son on 2022/11/17.
//

import UIKit

import PinLayout
import FlexLayout
import Differentiator

extension ChatListController {
    final class TableCell: RxBaseTableCell<SectionModel.Item> {
        private let avatarView = UIImageView()
        private let nameLabel = UILabel()
        private let msgLabel = UILabel()
        private let timeLabel = UILabel()
        private let unreadCntLabel = UILabel()
        
        public override func setupContainer() {
            super.setupContainer()
            
            self.rootContainer.flex.direction(.row)
                .alignItems(.center)
                .define { [weak self] in
                    guard let self = self else { return }
                    $0.addItem(self.avatarView)
                        .width(64).height(64)
                        .marginLeft(25)
                    
                    $0.addItem().direction(.row)
                        .justifyContent(.spaceBetween)
                        .define {
                            $0.addItem().define {
                                $0.addItem(self.nameLabel)
                                $0.addItem(self.msgLabel)
                                    .marginTop(4)
                            }
                            
                            $0.addItem().define {
                                $0.addItem(self.timeLabel)
                                $0.addItem(self.unreadCntLabel)
                                    .marginTop(7)
                                    .minWidth(28)
                                    .height(29)
                            }
                            .marginLeft(18)
                        }
                        .marginLeft(16)
                        .marginEnd(20)
                        .grow(1)
                }
        }
        
        public override func layout() {
            self.rootContainer.pin.all()
            self.rootContainer.flex.layout()
        }
        
        override func configure(with item: ChatListController.SectionModel.Item) {
            self.nameLabel.text = item.name
            self.msgLabel.text = item.lastMsg
            self.timeLabel.text = "4분전"
            self.unreadCntLabel.text = "\(item.unreadCnt)"
        }
        
        override func setAttrs() {
            self.nameLabel.font = .semiBold(size: 18)
            self.nameLabel.textColor = .hex3A3A3A
            self.msgLabel.font = .medium(size: 16)
            self.msgLabel.textColor = .hex5B5B5B
            self.timeLabel.font = .medium(size: 12)
            self.timeLabel.textColor = .hex5B5B5B
            self.unreadCntLabel.font = .regular(size: 16)
            self.unreadCntLabel.textColor = .white
            self.unreadCntLabel.layer.cornerRadius = 28 / 2
            self.unreadCntLabel.layer.backgroundColor = UIColor.hex06C755.cgColor
            self.unreadCntLabel.textAlignment = .center
            self.avatarView.layer.cornerRadius = 64 / 2
            self.avatarView.layer.masksToBounds = true
        }
    }
}

// TODO: API 구현시 데이터 모델 변경, CODomain 에 해야할 듯?
extension ChatListController {
    enum SectionModel: SectionModelType {
        struct Item: Codable {
            var avatarUrl: String
            var name: String
            var lastMsg: String
            var unreadCnt: Int
            var lastUpdatedTime: TimeInterval
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
