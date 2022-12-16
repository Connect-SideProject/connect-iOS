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
        private let fieldContainer = UIView()
        private let textView = UITextView()
        private let sendBtn = RoundRutton(cornerRadius: 12)
        
        override func setupContainer() {
            super.setupContainer()
            
            self.rootContainer.flex.direction(.row)
                .define { [weak self] in
                    guard let self = self else { return }
                    $0.addItem(self.fieldContainer)
                        .direction(.row)
                        .grow(1)
                        .marginTop(14)
                        .marginHorizontal(20)
                        .height(44)
                        .alignItems(.center)
                        .define {
                            $0.addItem(self.textView)
                                .marginLeft(5)
                                .grow(1)
                            
                            $0.addItem(self.sendBtn)
                                .marginLeft(5)
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
            self.fieldContainer.layer.cornerRadius = 12
            self.fieldContainer.layer.borderWidth = 1
            self.fieldContainer.layer.borderColor = UIColor.hexC6C6C6.cgColor
            self.textView.font = .regular(size: 16)
            self.sendBtn.layer.backgroundColor = UIColor.hex05A647.cgColor
            self.sendBtn.layer.borderWidth = .zero
            self.sendBtn.setImage(.init(named: "ic_chat_send_msg"), for: .normal)
        }
    }
}
