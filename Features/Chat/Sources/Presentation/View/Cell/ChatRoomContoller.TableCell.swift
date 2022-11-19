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
    final class TableCell: RxBaseTableCell<SectionModel.Item> {
        private let timeLabel = UILabel()
        private let msgLabel = PaddingLabel(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        
        public override func setupContainer() {
            super.setupContainer()
            
            self.rootContainer.flex.direction(.row)
                .alignItems(.baseline)
                .define { [weak self] in
                    guard let self = self else { return }
                    $0.addItem(self.timeLabel)
                    
                    $0.addItem(self.msgLabel)
                }
        }
        
        public override func layout() {
            self.rootContainer.pin.all()
            self.rootContainer.flex.layout()
        }
    }
}

// TODO: API 구현시 데이터 모델 변경, CODomain 에 해야할 듯?
extension ChatRoomController {
    enum SectionModel: SectionModelType {
        struct Item: Codable {
            var sender: String
            var msg: String
            var timestamp: TimeInterval
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
