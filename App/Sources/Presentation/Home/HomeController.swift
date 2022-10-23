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
final class HomeController: UIViewController {
    
    //MARK: Property
    
    typealias Reactor = HomeViewReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    
    private let floatingButton: UIButton = UIButton().then {
        $0.backgroundColor = UIColor.white
        $0.layer.masksToBounds = false
        $0.setImage(UIImage(named: "home_search_floating"), for: .normal)
    }
    
    private let homeIndicatorView:UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.backgroundColor = .gray
    }
    
    
    private let selectedLineView: UIView = UIView().then {
        $0.backgroundColor = UIColor.green04
    }
    
    
    private let homeScrollView: UIScrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    
    private let homeScrollContainerView: UIView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    
    let dataSource: RxCollectionViewSectionedReloadDataSource<HomeViewSection>
    
    
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
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    private let releaseFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var releaseCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: releaseFlowLayout).then {
        $0.backgroundColor = .gray01
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        
        
    }
    
    
    private static func dataSourcesFactory() -> RxCollectionViewSectionedReloadDataSource<HomeViewSection> {
        return .init(
            configureCell: { dataSoucre, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .homeMenu(cellReactor):
                    
                    guard let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as? HomeCategoryCell else { return UICollectionViewCell() }
                    
                    menuCell.reactor = cellReactor
                    return menuCell
                    
                case let .homeStudyMenu(cellReactor):
                    guard let studyMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeStudyMenuCell", for: indexPath) as? HomeStudyMenuCell else { return UICollectionViewCell() }
                    studyMenuCell.reactor = cellReactor
                    return studyMenuCell
                    
                case .homeStudyList:
                    guard let studyListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeStudyListCell", for: indexPath) as? HomeStudyListCell else { return UICollectionViewCell() }
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
                        
                        return homeStudyListView
                    default:
                        return UICollectionReusableView()
                    }
                default:
                    return UICollectionReusableView()
                }
            }
        )
    }
    
    
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        self.dataSource = type(of: self).dataSourcesFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(#function)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        configure()
    }
    
    override func viewWillLayoutSubviews() {
        floatingButton.addShadow(color: UIColor.gray06.cgColor, offset: CGSize(width: 0, height: 1), radius: 5, opacity: 0.2)
        floatingButton.layer.cornerRadius = floatingButton.frame.height / 2.0
    }
    
    
    private func configure() {
        let tabbarHeight: CGFloat = tabBarController?.tabBar.frame.size.height ?? 0.0
        
        [collectionView, floatingButton, homeIndicatorView, selectedLineView].forEach {
            view.addSubview($0)
        }
        self.view.bringSubviewToFront(self.homeIndicatorView)


        
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
//        releaseCollectionView.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.height.equalTo(318)
//            $0.bottom.equalToSuperview().offset(-tabbarHeight)
//        }
                
        floatingButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-(tabbarHeight + 12))
            $0.width.height.equalTo(75)
        }
        
        homeIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
    }
    
}



extension HomeController: ReactorKit.View {
    
    func bind(reactor: Reactor) {
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
        
        reactor.state
            .map { $0.section }
            .debug("Section Item ")
            .observe(on: MainScheduler.instance)
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        
        collectionView
            .rx.itemSelected
            .subscribe(onNext: { indexPath in
                switch self.dataSource[indexPath] {
                case .homeMenu:
                    break
                case .homeStudyMenu:
                    print("CollectionView Click Section")
                case .homeStudyList:
                    print("CollectionView StudyList Click")
                }
            }).disposed(by: disposeBag)
        
    }
}




extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch self.dataSource[section] {
        case .field:
            return CGSize(width: collectionView.frame.size.width, height: 44)
        default:
            return .zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.dataSource[indexPath] {
        case .homeMenu:
            return CGSize(width: 66, height: 66)
        case .homeStudyMenu:
            return CGSize(width: 60, height: 40)
        case .homeStudyList:
            return CGSize(width: collectionView.frame.size.width - 40, height: 97)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch self.dataSource[section] {
        case .homeSubMenu:
            return CGSize(width: collectionView.frame.size.width, height: 1)
        case .homeStudyList:
            return CGSize(width: collectionView.frame.size.width, height: 60)
        default:
            return .zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch self.dataSource[section] {
        case .field:
            return .zero
        case .homeSubMenu:
            return .zero
        case .homeStudyList:
            return 8
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch self.dataSource[section] {
        case .field:
            return .zero
        default:
            return .zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch self.dataSource[section] {
        case .field:
            return UIEdgeInsets(top: 25, left: 20, bottom: 0, right: 20)
        case .homeSubMenu:
            return UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        case .homeStudyList:
            return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    
}
