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
        self.setTable()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.rootContainer.backgroundColor = .yellow
        self.tableView.backgroundColor = .blue
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
            @Pulse var sectionModels = [SectionModel]()
        }
    }
}