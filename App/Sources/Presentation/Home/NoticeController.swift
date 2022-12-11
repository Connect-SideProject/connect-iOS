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
        $0.style = .medium
    }
    
    private lazy var leftBackButton: UIButton = UIButton().then {
        $0.setImage(UIImage(named: "ic_back_arrow"), for: .normal)
        $0.setTitle("알림", for: .normal)
        $0.titleLabel?.font = UIFont.semiBold(size: 16)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.setTitleColor(.hex3A3A3A, for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
    }
    
    private lazy var noticeBackButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftBackButton)
    
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        configure()
    }
    
    //MARK: Configure
    func configure() {
        
        self.navigationItem.leftBarButtonItem = noticeBackButtonItem
        
        _ = [noticeTableView, noticeIndicatorView].map {
            self.view.addSubview($0)
        }
        
        noticeIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
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
        
        leftBackButton
            .rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
    }
    
}
