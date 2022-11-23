//
//  ChatRoomContoller.InputArea.swift
//  Chat
//
//  Created by Taeyoung Son on 2022/11/22.
//

import UIKit

import COCommonUI

extension ChatRoomController {
    final class InputArea: FlexLayoutView {
        private let textField = UITextField()
        private let sendBtn = RoundRutton()
        
        override func setupContainer() {
            super.setupContainer()
        }
        
        override func layout() {
            self.rootContainer.pin.all()
            self.rootContainer.flex.layout()
        }
    }
}
