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
import RxCocoa


/// 홈 화면 컨트롤러.
final class HomeController: UIViewController, UIScrollViewDelegate {
    
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
    
    
    
    let dataSource: RxCollectionViewSectionedReloadDataSource<HomeViewSection>
    
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({ flowLayout in
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.itemSize = CGSize(width: 60, height: 40)
    })).then { collectionView in
        collectionView.register(HomeSearchResuableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSearchResuableHeaderView")
        collectionView.register(HomeCategoryCell.self, forCellWithReuseIdentifier: "HomeCategoryCell")
        collectionView.register(HomeStudyMenuCell.self, forCellWithReuseIdentifier: "HomeStudyMenuCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
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
                    let studyMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeStudyMenuCell", for: indexPath) as? HomeStudyMenuCell
                    studyMenuCell?.reactor = cellReactor
                    return studyMenuCell!
                
                }
            },configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    switch dataSource[indexPath] {
                    case .homeStudyMenu:
                        guard let searchHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSearchResuableHeaderView", for: indexPath) as? HomeSearchResuableHeaderView else { return UICollectionReusableView() }
                        return searchHeaderView
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
        [collectionView, floatingButton, homeIndicatorView].forEach {
            view.addSubview($0)
        }
        self.view.bringSubviewToFront(self.homeIndicatorView)
        
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-15)
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
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { indexPath in
                switch self.dataSource[indexPath] {
                case .homeMenu:
                    break
                case .homeStudyMenu:
                    print("CollectionView Click Section")
                }
            }).disposed(by: disposeBag)
        
    }
}




extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch self.dataSource[section] {
        case .homeSubMenu:
            return CGSize(width: collectionView.frame.size.width, height: 44)
        default:
            return .zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch self.dataSource[section] {
        case .field:
            return 1
        case .homeSubMenu:
            return .zero
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch self.dataSource[section] {
        case .homeSubMenu:
            return UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        default:
            return .zero
        }
    }
    
    
    
}
