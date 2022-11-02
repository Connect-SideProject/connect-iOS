//
//  MessaeController.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

import RxSwift
import RxDataSources
import ReactorKit

final class ChatListController: ChatBaseController<ChatListController.Reactor> {
    private let tableView = UITableView()
    
    override func setupContainer() {
        
    }
    
    override func setAttrs() {
        
    }
    
    override func bind(reactor: Reactor) {
        
    }
}

extension ChatListController {
    final class Reactor: ReactorKit.Reactor {
        var initialState: State = .init()
        enum Action { }
        struct State { }
    }
}
