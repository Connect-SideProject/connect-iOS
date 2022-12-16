//
//  ChatRoomContoller.TableCell.swift
//  Chat
//
//  Created by Taeyoung Son on 2022/11/19.
//

import UIKit

import PinLayout
import FlexLayout
import Differentiator
import COCommonUI

extension ChatRoomController {
    class TableCell: RxBaseTableCell<SectionModel.MessageData> {
        let timeLabel = UILabel()
        let msgLabel = PaddingLabel(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        let msgMaxWidth = UIScreen.main.bounds.width * (60 / 100)
        
        override func configure(with item: ChatRoomController.SectionModel.MessageData) {
            self.msgLabel.text = item.msg
            self.timeLabel.text = "오후 01:26"
        }
        
        public override func layout() {
            self.contentView.flex.layout(mode: .adjustHeight)
        }
        
        override func setAttrs() {
            self.backgroundColor = .clear
            self.msgLabel.numberOfLines = 0
            self.msgLabel.lineBreakMode = .byWordWrapping
            self.msgLabel.font = .medium(size: 14)
            self.msgLabel.preferredMaxLayoutWidth = self.msgMaxWidth
            self.timeLabel.textColor = .hex818181
            self.timeLabel.font = .medium(size: 10)
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            self.contentView.pin.width(size.width)
            self.layout()
            return self.contentView.frame.size
        }
    }
    
    final class ReceivedMsgCell: TableCell {
        
        public override func setupContainer() {
            self.contentView.flex.direction(.row)
                .alignItems(.end)
                .define { [weak self] in
                    guard let self = self else { return }
                    $0.addItem(self.msgLabel)
                        .marginTop(10)
                        .marginLeft(23)
                        .maxWidth(self.msgMaxWidth)
                    
                    $0.addItem(self.timeLabel)
                }
        }
        
        override func layout() {
            super.layout()
            self.msgLabel.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 12)
        }
        
        override func setAttrs() {
            super.setAttrs()
            self.msgLabel.textColor = .black
            self.msgLabel.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
    final class SentMsgCell: TableCell {
        
        public override func setupContainer() {
            self.contentView.flex.direction(.rowReverse)
                .alignItems(.end)
                .define { [weak self] in
                    guard let self = self else { return }
                    $0.addItem(self.msgLabel)
                        .marginTop(10)
                        .marginEnd(23)
                        .maxWidth(self.msgMaxWidth)
                    
                    $0.addItem(self.timeLabel)
                }
        }
        
        override func layout() {
            super.layout()
            self.msgLabel.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 12)
        }
        
        override func setAttrs() {
            super.setAttrs()
            self.msgLabel.textColor = .white
            self.msgLabel.layer.backgroundColor = UIColor.hex05A647.cgColor
        }
    }
}

// TODO: API 구현시 데이터 모델 변경, CODomain 에 해야할 듯?
extension ChatRoomController {
    enum SectionModel: SectionModelType {
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
        enum Item {
            case sent(data: MessageData), received(data: MessageData)
        }
        
        struct MessageData: Codable {
            var sender: String
            var msg: String
            var timestamp: TimeInterval
        }
    }
}
