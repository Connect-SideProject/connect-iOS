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
            
            self.rootContainer.flex
                .direction(.row)
                .define { [weak self] in
                    guard let self = self else { return }
                    $0.addItem(self.avatarView)
                        .width(64).height(64)
                        .marginLeft(25)
                    
                    $0.addItem().direction(.column).define {
                        $0.addItem(self.nameLabel)
                        $0.addItem(self.msgLabel)
                    }
                    .marginLeft(16)
                    
                    $0.addItem().direction(.column).define {
                        $0.addItem(self.timeLabel)
                        $0.addItem(self.unreadCntLabel)
                    }
                    .marginLeft(16)
                    .marginEnd(20)
                }
        }
        
        public override func layout() {
            self.rootContainer.pin.all()
            self.rootContainer.flex.layout()
        }
        
        override func configure(with item: ChatListController.SectionModel.Item) {
            self.nameLabel.text = item.lastMsg
            self.msgLabel.text = item.lastMsg
            self.timeLabel.text = "4분전"
            self.unreadCntLabel.text = "3"
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
