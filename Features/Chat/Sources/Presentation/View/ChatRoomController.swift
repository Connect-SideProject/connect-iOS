//
//  ChatRoomController.swift
//  Chat
//
//  Created by Taeyoung Son on 2022/11/19.
//

import UIKit

import ReactorKit
import COExtensions
import COCommonUI

public final class ChatRoomController: ChatBaseController<ChatRoomController.Reactor> {
    private let tableView = UITableView()
    private let titleView = TitleView()
    
    public override func setupContainer() {
        super.setupContainer()
        
        self.rootContainer.flex.define { [weak self] in
            guard let self = self else { return }
            $0.addItem(self.titleView)
                .height(50)
            $0.addItem(self.tableView)
                .grow(1)
        }
    }
    
    public override func setAttrs() {
        self.rootContainer.backgroundColor = .yellow
        self.tableView.backgroundColor = .blue
    }
    
    public override func layout() {
        self.rootContainer.pin.all()
        let safe = UIApplication.keyWindow?.safeAreaInsets
        self.rootContainer.flex.margin(safe ?? self.view.safeAreaInsets).layout()
    }
}

extension ChatRoomController {
    final public class Reactor: ReactorKit.Reactor {
        public var initialState: State = .init()
        public enum Action { }
        public struct State { }
    }
}
