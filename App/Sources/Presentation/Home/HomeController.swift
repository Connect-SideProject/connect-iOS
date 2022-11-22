//
//  HomeController.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit
import ReactorKit
import RxDataSources
import Then
import RxSwift
import RxCocoa
import CONetwork
import COManager
import CODomain


/// 홈 화면 컨트롤러.
public final class HomeController: UIViewController {
    
    //MARK: Property
    
    public typealias Reactor = HomeViewReactor
    
    public weak var delegate: HomeCoordinatorDelegate?
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    
    private let floatingButton: UIButton = UIButton().then {
        $0.backgroundColor = UIColor.white
        $0.layer.masksToBounds = false
        $0.setImage(UIImage(named: "home_search_floating"), for: .normal)
    }
    
    private let childrenDependency: HomeDependencyContainer = HomeDependencyContainer(homeApiService: ApiManager.shared)
    
    private let homeIndicatorView:UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.backgroundColor = .clear
    }
    
    private let homeNavgaionBar: HomeNavigationBarView = HomeNavigationBarView()
    
    
    private let homeScrollView: UIScrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    
    private let homeScrollContainerView: UIView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let releaseDataSource: RxCollectionViewSectionedReloadDataSource<HomeReleaseSection>
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<HomeViewSection> = .init(
        configureCell: { dataSource, collectionView, indexPath, sectionItem in
            switch sectionItem {
            case let .homeMenu(cellReactor):
                
                guard let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as? HomeCategoryCell else { return UICollectionViewCell() }
                
                menuCell.reactor = cellReactor
                return menuCell
                
            case let .homeStudyMenu(cellReactor):
                guard let studyMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeStudyMenuCell", for: indexPath) as? HomeStudyMenuCell else { return UICollectionViewCell() }
                studyMenuCell.reactor = cellReactor
                return studyMenuCell
                
            case let .homeStudyList(cellReactor):
                guard let studyListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeStudyListCell", for: indexPath) as? HomeStudyListCell else { return UICollectionViewCell() }
                studyListCell.reactor = cellReactor
                return studyListCell
            }
        },configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                switch dataSource[indexPath.section] {
                case .field:
                    guard let searchHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSearchResuableHeaderView", for: indexPath) as? HomeSearchResuableHeaderView else { return UICollectionReusableView() }
                    return searchHeaderView
                default:
                    return UICollectionReusableView()
                }
            case UICollectionView.elementKindSectionFooter:
                switch dataSource[indexPath.section] {
                case .homeSubMenu:
                    guard let homeMenuUnderLineView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeStudyMenuFooterView", for: indexPath) as? HomeStudyMenuFooterView else { return UICollectionReusableView() }
                    
                    return homeMenuUnderLineView
                case .homeStudyList:
                    guard let homeStudyListView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeStudyListFooterView", for: indexPath) as? HomeStudyListFooterView else { return UICollectionReusableView() }
                    homeStudyListView.completion = {
                        self.delegate?.didTapToPostListCreate()
                    }
                    return homeStudyListView
                default:
                    return UICollectionReusableView()
                }
            default:
                return UICollectionReusableView()
            }
        })

    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({ flowLayout in
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
    })).then {
        $0.register(HomeSearchResuableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSearchResuableHeaderView")
        $0.register(HomeStudyMenuFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeStudyMenuFooterView")
        $0.register(HomeStudyListFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeStudyListFooterView")
        $0.register(HomeCategoryCell.self, forCellWithReuseIdentifier: "HomeCategoryCell")
        $0.register(HomeStudyMenuCell.self, forCellWithReuseIdentifier: "HomeStudyMenuCell")
        $0.register(HomeStudyListCell.self, forCellWithReuseIdentifier: "HomeStudyListCell")
        $0.register(HomeStudyEmptyCell.self, forCellWithReuseIdentifier: "HomeStudyEmptyCell")
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
    }
    
    private let releaseFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = .zero
        $0.minimumInteritemSpacing = 10
        $0.itemSize = CGSize(width: 217, height: 227)
        
    }
    
    private let releaseHeaderTitleLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.sizeToFit()
        $0.text = "실시간 HOT 게시글"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private lazy var releaseCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: releaseFlowLayout).then {
        $0.backgroundColor = .hexF9F9F9
        $0.register(HomeReleaseStudyListCell.self, forCellWithReuseIdentifier: "HomeReleaseStudyListCell")
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
    }
    
    
    private static func releaseSourceFactory() -> RxCollectionViewSectionedReloadDataSource<HomeReleaseSection> {
        
        return .init(configureCell:  { dataSource, collectionView, indexPath, sectionItem in
            switch sectionItem {
            case let .hotList(cellReactor):
                guard let hotListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeReleaseStudyListCell", for: indexPath) as? HomeReleaseStudyListCell else { return UICollectionViewCell() }
                
                hotListCell.reactor = cellReactor
                return hotListCell
                
            }
        })
    }
    
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        self.releaseDataSource = type(of: self).releaseSourceFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(#function)
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
      

      
        configure()
    }
    
    public override func viewWillLayoutSubviews() {
        floatingButton.addShadow(color: UIColor.hex3A3A3A.cgColor, offset: CGSize(width: 0, height: 1), radius: 5, opacity: 0.2)
        floatingButton.layer.cornerRadius = floatingButton.frame.height / 2.0
    }
    
    
    private func configure() {
        
        self.view.addSubview(homeScrollView)
        self.view.addSubview(homeNavgaionBar)
        homeScrollView.addSubview(homeScrollContainerView)
        self.view.addSubview(releaseHeaderTitleLabel)
        
        _ = [homeIndicatorView, collectionView ,releaseCollectionView, floatingButton].map {
            homeScrollContainerView.addSubview($0)
        }
        
        homeNavgaionBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        homeScrollView.snp.makeConstraints {
            $0.top.equalTo(homeNavgaionBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        homeScrollContainerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(650)
        }
        
        releaseCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom)
            $0.height.equalTo(318)
            $0.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.height.equalTo(75)
        }
        
        homeIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(12)
        }
        
        releaseHeaderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(releaseCollectionView.snp.top).offset(25)
            $0.right.equalToSuperview()
            $0.height.equalTo(22)
            $0.left.equalToSuperview().inset(18)
        }
        
    }
    
}



extension HomeController: ReactorKit.View {
    
    public func bind(reactor: Reactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bindCollectionView(reactor: reactor)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: homeIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
    }
    
    
}

extension HomeController {
    
    func bindCollectionView(reactor: Reactor) {
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.releaseCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.section }
            .debug("Section Item ")
            .observe(on: MainScheduler.instance)
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.releaseSection}
            .debug("release Section Item")
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseCollectionView.rx.items(dataSource: self.releaseDataSource))
            .disposed(by: disposeBag)
                
        collectionView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                switch self.dataSource[indexPath] {
                case .homeMenu:
                    self.delegate?.didTapToPostListCreate()
                case let .homeStudyMenu(reactor):
                    HomeViewTransform.event.onNext(.didSelectHomeMenu(type: reactor))
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
    }
}




extension HomeController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch self.dataSource[section] {
        case .field:
            return CGSize(width: collectionView.frame.size.width, height: 44)
        default:
            return .zero
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            switch self.dataSource[indexPath] {
            case .homeMenu:
                return CGSize(width: 66, height: 66)
            case .homeStudyMenu:
                return CGSize(width: 60, height: 40)
            case .homeStudyList:
                return CGSize(width: collectionView.frame.size.width - 40, height: 97)
            }
        } else {
            switch self.releaseDataSource[indexPath] {
            case .hotList:
                return CGSize(width: 218, height: 227)
            }
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch self.dataSource[section] {
        case .homeSubMenu:
            return CGSize(width: collectionView.frame.size.width, height: 1)
        case .homeStudyList:
            return CGSize(width: collectionView.frame.size.width, height: 60)
        default:
            return .zero
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            switch self.dataSource[section] {
            case .field:
                return .zero
            case .homeSubMenu:
                return .zero
            case .homeStudyList:
                return 8
            }
        } else {
            switch self.releaseDataSource[section] {
            case .hotMenu:
                return 10
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            switch self.dataSource[section] {
            case .field:
                return .zero
            default:
                return .zero
            }
        } else {
            switch self.releaseDataSource[section] {
            case .hotMenu:
                return 10
            }
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionView {
            switch self.dataSource[section] {
            case .field:
                return UIEdgeInsets(top: 25, left: 20, bottom: 0, right: 20)
            case .homeSubMenu:
                return UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
            case .homeStudyList:
                return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            }
        } else {
            switch self.releaseDataSource[section] {
            case .hotMenu:
                return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20)
            }
        }
    }
    
    
    
}
