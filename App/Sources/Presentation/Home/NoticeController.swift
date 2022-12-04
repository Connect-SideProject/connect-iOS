//
//  NoticeController.swift
//  App
//
//  Created by Kim dohyun on 2022/12/04.
//

import UIKit
import Then
import SnapKit


import RxDataSources
import ReactorKit


/// 알림 리스트 화면 컨트롤러
public final class NoticeController: UIViewController {
    
    
    //MARK: Property
    
    public typealias Reactor = NoticeViewReactor
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var noticeIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.backgroundColor = .gray
    }
    
    private lazy var noticeTableView: UITableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.register(NoticeTableViewCell.self, forCellReuseIdentifier: "NoticeTableViewCell")
    }
    
    private lazy var noticeDataSource: RxTableViewSectionedReloadDataSource<NoticeSection> = .init(configureCell: { dataSource, tableView, indexPath, sectionItem in
        
        switch sectionItem {
        case .noticeItem:
            guard let noticeCell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as? NoticeTableViewCell else { return UITableViewCell() }
            
            return noticeCell
        }

    })
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Configure
    func configure() {
        _ = [noticeTableView, noticeIndicatorView].map {
            self.view.addSubview($0)
        }
        
        noticeIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        noticeTableView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        
    }
    
}



extension NoticeController: ReactorKit.View {
    
    
    public func bind(reactor: Reactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .observe(on: MainScheduler.instance)
            .bind(to: noticeIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
    }
    
}
