//
//  ChatRoomContoller.InputArea.swift
//  Chat
//
//  Created by Taeyoung Son on 2022/11/22.
//

import UIKit

import PinLayout
import FlexLayout
import COCommonUI

extension ChatRoomController {
    final class InputArea: FlexLayoutView {
        private let textField = UITextField()
        private let sendBtn = RoundRutton(cornerRadius: 12)
        
        override func setupContainer() {
            super.setupContainer()
            
            self.rootContainer.flex.direction(.row)
                .alignItems(.center)
                .define { [weak self] in
                    guard let self = self else { return }
                    $0.addItem(self.textField)
                        .grow(1)
                        .marginHorizontal(20)
                        .height(44)
                        .alignItems(.end)
                        .define {
                            $0.addItem(self.sendBtn)
                                .width(48).height(44)
                        }
                }
        }
        
        override func layout() {
            self.rootContainer.pin.all()
            self.rootContainer.flex.layout()
        }
        
        override func setAttrs() {
            super.setAttrs()
            self.textField.layer.cornerRadius = 12
            self.textField.layer.borderWidth = 1
            self.textField.layer.borderColor = UIColor.hexC6C6C6.cgColor
            self.sendBtn.layer.backgroundColor = UIColor.hex05A647.cgColor
            self.sendBtn.layer.borderWidth = .zero
            self.sendBtn.setImage(.init(named: "ic_chat_send_msg"), for: .normal)
        }
    }
}
