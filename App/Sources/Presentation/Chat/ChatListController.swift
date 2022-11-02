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
import FlexLayout
import COExtensions

final class ChatListController: ChatBaseController<ChatListController.Reactor> {
    
    private let tableView = UITableView()
    
    override func setupContainer() {
        super.setupContainer()
        
        self.rootContainer.flex.define { [weak self] in
            guard let self = self else { return }
            $0.addItem(self.tableView)
                .grow(1)
        }
    }
    
    override func setAttrs() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.rootContainer.backgroundColor = .yellow
        self.tableView.backgroundColor = .blue
    }
    
    override func layout() {
        self.rootContainer.pin.all()
        let safe = UIApplication.keyWindow?.safeAreaInsets
        self.rootContainer.flex.margin(safe ?? self.view.safeAreaInsets).layout()
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
