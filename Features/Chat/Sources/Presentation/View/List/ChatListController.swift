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
import PinLayout
import FlexLayout
import COExtensions
import COCommonUI

public final class ChatListController: ChatBaseController<ChatListController.Reactor> {
    
    private let tableView = UITableView()
    private let titleView = TitleView().set(title: "대화 목록")
    private var dataSource = RxTableViewSectionedReloadDataSource<SectionModel> { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseableIdentifier, for: indexPath) as! TableCell
        cell.configure(with: dataSource[indexPath])
        return cell
    }
    
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
        super.setAttrs()
        self.setTable()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func layout() {
        self.rootContainer.pin.all()
        let safe = UIApplication.keyWindow?.safeAreaInsets
        self.rootContainer.flex.margin(safe ?? self.view.safeAreaInsets).layout()
    }
    
    public override func bind(reactor: Reactor) {
        reactor.pulse(\.$sectionModels).share()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func setTable() {
        self.tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.reuseableIdentifier)
        self.tableView.rowHeight = 92
    }
}

extension ChatListController {
    final public class Reactor: ReactorKit.Reactor {
        public var initialState: State = .init()
        public enum Action { }
        public struct State {
            @Pulse var sectionModels: [SectionModel] = [.basic(items: .init(repeating: .init(avatarUrl: "https://w.namu.la/s/e4d8ce8f85cf0124f2d1e1dda636e568b352ec8369de9364f308b32ec2e92ed5af58206481b367dee2a45cc33b919459b4102589e12c12e7f29e8b48392ed144bc3b7de5e89167e70fefc2f15ba2fc23bfdb466fcd1580357fd9fe767af2dfd768fa4008564d484818c14aeeffab3fc1", name: "아바타", lastMsg: "와칸다 포에버", unreadCnt: 1, lastUpdatedTime: Date().timeIntervalSince1970), count: 10))]
        }
    }
}
