//
//  MeetingDetailController.swift
//  Meeting
//
//  Created by Taeyoung Son on 2022/12/04.
//

import UIKit

import RxSwift
import ReactorKit
import RxDataSources
import COCommonUI
import COExtensions
import CONetwork
import CODomain

public final class MeetingDetailController: ReactorBaseController<MeetingDetailController.Reactor> {
    private let titleView = TitleView()
    private let topArea = TopArea()
    private let tableView = UITableView()
    private var dataSource = RxTableViewSectionedReloadDataSource<SectionModel> { dataSource, tableView, indexPath, item in
        switch dataSource[indexPath] {
        case .card(let info):
            let cell = tableView.dequeueReusableCell(withIdentifier: CardTableCell.reuseableIdentifier, for: indexPath) as! CardTableCell
            cell.configure(with: info)
            return cell
        case .default(let pair):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextTableCell.reuseableIdentifier, for: indexPath) as! TextTableCell
            cell.configure(with: pair)
            return cell
        }
    }
    
    public override func setupContainer() {
        super.setupContainer()
        
        self.rootContainer.flex.define {
            $0.addItem(self.titleView)
                .height(50)
            
            $0.addItem(self.topArea)
            
            $0.addItem(self.tableView)
                .grow(1)
        }
    }
    
    public override func layout() {
        self.rootContainer.pin.all()
        let safe = UIApplication.keyWindow?.safeAreaInsets
        self.rootContainer.flex.margin(safe ?? self.view.safeAreaInsets).layout()
    }
    
    public override func bind(reactor: Reactor) {
        self.bindTopArea()
        
        self.reload.share()
            .map { Reactor.Action.reload }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$meetingInfo).share()
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(onNext: self.configure(with:))
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$sectionModels).share()
            .asDriver(onErrorJustReturn: [])
            .drive(self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func bindTopArea() {
        func indexPath(for case: TopArea.TitleCases) -> IndexPath {
            switch `case` {
            case .info:
                return .init(row: 0, section: 0)
            case .detail:
                return .init(row: 1, section: 0)
            case .location:
                return .init(row: 2, section: 0)
            }
        }
        
        self.topArea.selectedCase.share()
            .distinctUntilChanged()
            .map(indexPath(for:))
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.tableView.scrollToRow(at: $0, at: .top, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    public override func setAttrs() {
        super.setAttrs()
        self.setTitleView()
        self.setTable()
    }
    
    private func setTitleView() {
        self.titleView.set(title: "프로젝트 정보")
            .setLeftBtn(type: .back)
            .setRightInnerBtn(type: .star)
            .setRightOuterBtn(type: .share)
    }
    
    private func configure(with info: MeetingInfo) { }
    
    private func setTable() {
        self.tableView.register(CardTableCell.self, forCellReuseIdentifier: CardTableCell.reuseableIdentifier)
        self.tableView.register(TextTableCell.self, forCellReuseIdentifier: TextTableCell.reuseableIdentifier)
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}

extension MeetingDetailController {
    final public class Reactor: ReactorKit.Reactor {
        init(id: Int) {
            self.initialState = .init(id: id)
        }
        public var initialState: State
        public enum Action {
            case reload
        }
        
        public enum Mutation {
            case setMeetingInfo(MeetingInfo)
        }
        
        public struct State {
            var id: Int
            @Pulse var meetingInfo: MeetingInfo?
            @Pulse var sectionModels = [SectionModel]()
        }
        
        public func mutate(action: Action) -> Observable<Mutation> {
            switch action {
            case .reload:
                // TODO: 추후에 의존성 주입 필요(ApiService)
                let meetingInfo = ApiManager.shared
                    .request(endPoint: .init(path: .meetingDetail(id: self.currentState.id)))
                    .map(Mutation.setMeetingInfo)
                return meetingInfo
            }
        }
        
        public func reduce(state: State, mutation: Mutation) -> State {
            var new = state
            switch mutation {
            case .setMeetingInfo(let info):
                new.meetingInfo = info
                let items = self.makeSectionItems(for: info)
                new.sectionModels = [.basic(items: items)]
            }
            return new
        }
        
        private func makeSectionItems(for info: MeetingInfo) -> [SectionModel.Item] {
            var items = [SectionModel.Item]()
            items.append(.card(info))
            items.append(.default((title: "모임상세", description: info.studyInfo)))
            items.append(.default((title: "모임위치", description: info.place.name)))
            return items
        }
    }
}

extension MeetingDetailController {
    final class TopArea: FlexLayoutView {
        private let titleLabel = UILabel()
        private let avatarView = ProfileImageView()
        private let profileLabel = UILabel()
        private let tabItems = [UIButton(), UIButton(), UIButton()]
        private let tabUnderLineView = UIView()
        
        let selectedCase = BehaviorSubject<TitleCases>(value: .info)
        
        enum TitleCases: String, CaseIterable {
            case info = "모집정보"
            case detail = "모임상세"
            case location = "모임위치"
        }
        
        override func setupContainer() {
            self.flex.define {
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
            let titles = TitleCases.allCases.map(\.rawValue)
            self.tabItems.enumerated().forEach { idx, btn in
                btn.setTitle(titles[idx], for: .normal)
            }
        }
    }
}
