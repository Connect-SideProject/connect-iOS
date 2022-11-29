//
//  PostListController.swift
//  connect
//
//  Created by Kim dohyun on 2022/06/12.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxDataSources
import ReactorKit
import COCommonUI



/// 프로젝트 리스트 화면 컨트롤러
public final class PostListController: UIViewController {
    
    //MARK: Property
    
    public typealias Reactor = PostListReactor
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private let postListIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var  postFilterHeaderView: PostFilterHeaderView = PostFilterHeaderView(reactor: PostFilterReactor(bottomSheetItem: self.reactor?.currentState.bottomSheetItem ?? []))
    
    
    private let postTableView: UITableView = UITableView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .hexF9F9F9
        $0.register(PostStduyListCell.self, forCellReuseIdentifier: "PostStduyListCell")
    }
    
    private let postDataSource: RxTableViewSectionedReloadDataSource<PostSection>
    
    private static func postSourceFactory() -> RxTableViewSectionedReloadDataSource<PostSection> {
        return .init(configureCell: { dataSource, tableView, indexPath, sectionItem in
            guard let postListCell = tableView.dequeueReusableCell(withIdentifier: "PostStduyListCell", for: indexPath) as? PostStduyListCell else { return UITableViewCell() }
            return postListCell
        })
    }
    
    
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        self.postDataSource = type(of: self).postSourceFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        debugPrint(#function)
    }
    
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        configure()
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: Configure
    private func configure(){
        
        postFilterHeaderView.delegate = self
        
        self.view.backgroundColor = .white
        
        _ = [postListIndicatorView, postFilterHeaderView ,postTableView].map {
            self.view.addSubview($0)
        }
        
        postFilterHeaderView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        postListIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        postTableView.snp.makeConstraints {
            $0.top.equalTo(postFilterHeaderView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        
    }
    
    
}



extension PostListController: ReactorKit.View {
    
    
    public func bind(reactor: Reactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.bottomSheetItem }
            .bind { item in
                PostFilterTransform.event.onNext(.responseSheetItem(item: item))
            }.disposed(by: disposeBag)
        
    }
    
}

    //MARK: Delegate
extension PostListController: PostCoordinatorDelegate {
    
    public func didFilterSheetCreate(_ type: BottomSheetType) {
      BottomSheet(type: type)
        .show()
        .handler = { state in
            switch state {
            case let .confirm(_, text):
                switch type {
                case .onOffLine:
                    PostFilterTransform.event.onNext(.didTapOnOffLineSheet(text: text, completion: {
                        //TODO: 서버 통신 Action Transfrom 추가
                    }))
                case .interest:
                    PostFilterTransform.event.onNext(.didTapInterestSheet(text: text))
                case .studyType:
                    PostFilterTransform.event.onNext(.didTapStudyTypeSheet(text: text))
                case .aligment:
                    PostFilterTransform.event.onNext(.didTapAligmentSheet(text: text))
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
}
