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
    private let titleView = TitleView().setLeftBtn(type: .back)
    private lazy var inputArea = InputArea()
    
    private static var inputAreaHeight: CGFloat = 73
    private var safeBottom: CGFloat { UIApplication.keyWindow?.safeAreaInsets.bottom ?? 0 }
    
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
            
            $0.addItem(self.inputArea)
                .height(73)
        }
    }
    
    public override func setAttrs() {
        self.setTable()
        self.addObservers()
        self.addGestureRec()
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .hexEDEDED
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

// TODO: 정리좀
extension ChatRoomController {
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ noti: Notification) {
        if let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.inputArea.flex.marginBottom(keyboardHeight - self.safeBottom)
            self.inputArea.flex.markDirty()
            self.view.setNeedsLayout()
        }
    }
    
    @objc private func keyboardWillHide(_ noti: Notification) {
        self.inputArea.flex.marginBottom(0)
        self.inputArea.flex.markDirty()
        self.view.setNeedsLayout()
    }
    
    private func addGestureRec() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
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
