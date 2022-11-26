//
//  ChatRoomController.swift
//  Chat
//
//  Created by Taeyoung Son on 2022/11/19.
//

import UIKit

import ReactorKit
import RxDataSources
import COExtensions
import COCommonUI

public final class ChatRoomController: ChatBaseController<ChatRoomController.Reactor> {
    private let tableView = UITableView()
    private let titleView = TitleView()
    
    private var dataSource = RxTableViewSectionedReloadDataSource<SectionModel> { dataSource, tableView, indexPath, item in
        switch dataSource[indexPath] {
        case .received(let data):
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedMsgCell.reuseableIdentifier, for: indexPath) as! ReceivedMsgCell
            cell.configure(with: data)
            return cell
        case .sent(let data):
            let cell = tableView.dequeueReusableCell(withIdentifier: SentMsgCell.reuseableIdentifier, for: indexPath) as! SentMsgCell
            cell.configure(with: data)
            return cell
        }
    }
    
    public override func setupContainer() {
        super.setupContainer()
        
        self.rootContainer.flex.define { [weak self] in
            guard let self = self else { return }
            $0.addItem(self.titleView)
                .height(50)
            $0.addItem(self.tableView)
                .grow(1)
            
            $0.addItem(InputArea())
                .height(73)
        }
    }
    
    public override func setAttrs() {
        self.setTable()
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
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.register(ReceivedMsgCell.self, forCellReuseIdentifier: ReceivedMsgCell.reuseableIdentifier)
        self.tableView.register(SentMsgCell.self, forCellReuseIdentifier: SentMsgCell.reuseableIdentifier)
        self.tableView.separatorStyle = .none
    }
}

extension ChatRoomController {
    final public class Reactor: ReactorKit.Reactor {
        public var initialState: State = .init()
        public enum Action { }
        public struct State {
            @Pulse var sectionModels = [SectionModel]()
        }
    }
}
