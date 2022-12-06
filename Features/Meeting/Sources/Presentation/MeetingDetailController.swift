//
//  MeetingDetailController.swift
//  Meeting
//
//  Created by Taeyoung Son on 2022/12/04.
//

import UIKit

import RxSwift
import ReactorKit
import COCommonUI
import COExtensions

public final class MeetingDetailController: ReactorBaseController<MeetingDetailController.Reactor> {
    private let titleView = TitleView()
    private let topArea = TopArea()
    private let tableView = UITableView()
    
    public override func setupContainer() {
        super.setupContainer()
        
        self.rootContainer.flex.define { [weak self] in
            guard let self = self else { return }
            $0.addItem(self.titleView)
                .height(50)
            $0.addItem(self.topArea)
                .height(128)
            $0.addItem(self.tableView)
                .grow(1)
        }
    }
    
    public override func layout() {
        self.rootContainer.pin.all()
        let safe = UIApplication.keyWindow?.safeAreaInsets
        self.rootContainer.flex.margin(safe ?? self.view.safeAreaInsets).layout()
    }
    
    public override func setAttrs() {
        super.setAttrs()
        self.setTitleView()
    }
    
    private func setTitleView() {
        self.titleView.set(title: "프로젝트 정보")
            .setLeftBtn(type: .back)
            .setRightInnerBtn(type: .star)
            .setRightOuterBtn(type: .share)
    }
}

extension MeetingDetailController {
    final public class Reactor: ReactorKit.Reactor {
        public var initialState = State()
        public enum Action { }
        public struct State { }
    }
}

extension MeetingDetailController {
    final class TopArea: FlexLayoutView {
        private let titleLabel = UILabel()
        private let avatarView = ProfileImageView()
        private let profileLabel = UILabel()
        private let tabItems = [UIButton(), UIButton(), UIButton()]
        private let tabUnderLineView = UIView()
        
        override func setupContainer() {
            self.flex.define { [weak self] in
                guard let self = self else { return }
                $0.addItem(self.titleLabel)
                    .marginTop(16)
                    .height(22)
                    .marginHorizontal(20)
                
                $0.addItem().direction(.row)
                    .height(24)
                    .marginTop(8)
                    .marginHorizontal(20)
                    .define {
                        $0.addItem(self.avatarView)
                            .width(24).height(24)
                        
                        $0.addItem(self.profileLabel)
                            .marginLeft(8)
                    }
                
                $0.addItem().direction(.row)
                    .marginTop(30)
                    .alignItems(.baseline)
                    .justifyContent(.spaceEvenly)
                    .define { flex in
                        self.tabItems.enumerated().forEach { index, item in
                            flex.addItem(item)
                                .height(19)
                        }
                    }
                
                $0.addItem(self.tabUnderLineView)
                    .marginTop(8)
                    .width(41).height(1)
            }
        }
        
        override func setAttrs() {
            super.setAttrs()
            self.setTabItems()
        }
        
        private func setTabItems() {
            let titles = ["모집정보", "모임상세", "모임위치"]
            self.tabItems.enumerated().forEach { idx, btn in
                btn.setTitle(titles[idx], for: .normal)
            }
        }
    }
}

extension MeetingDetailController {
    final class CardTableCell: RxBaseTableCell<Any> {
        
    }
    
    final class TextTableCell: RxBaseTableCell<Any> {
        private let titleLabel = UILabel()
        private let descLabel = UILabel()
    }
}
