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
import RxSwift
import RxCocoa
import RxDataSources


/// 홈 화면 컨트롤러.
class HomeController: UIViewController {
    
    //MARK: Property
    var disposeBag: DisposeBag = DisposeBag()
    
    
    private let floatingButton: UIButton = {
        $0.backgroundColor = .black
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        
        return $0
    }(UIButton())
    
    
    let datasources: RxCollectionViewSectionedReloadDataSource<HomeViewSection>
    
        private lazy var collectionView: UICollectionView = {
        
            let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    
    static func dataSourcesFactory() -> RxCollectionViewSectionedReloadDataSource<HomeViewSection> {
        return .init { datasource, collectionView, indexPath, sectionItem in
            switch sectionItem {
            case let .filter(reactor):
                let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFilterCell", for: indexPath) as? HomeFilterCell
                filterCell?.reactor = reactor
                
                return filterCell!
            case .location:
                let locationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCountryCategoryCell", for: indexPath) as? HomeCountryCategoryCell
                return locationCell!
            case .field:
                let fieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as? HomeCategoryCell
                return fieldCell!
            case .realTime:
                let realTimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeUserPostCell", for: indexPath) as? HomeUserPostCell
                return realTimeCell!
            case .user:
                let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecruitUserCell", for: indexPath) as? HomeRecruitUserCell
                return userCell!
            }
        }
    }
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        self.datasources = type(of: self).dataSourcesFactory()
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        configure()
    }
    
    override func viewWillLayoutSubviews() {
        floatingButton.layer.cornerRadius = floatingButton.frame.width / 2.0
    }
    
    
    private func configure() {
        view.backgroundColor = .white
        [collectionView,floatingButton].forEach {
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.width.height.equalTo(75)
        }
        
        
        setCollectionViewRegister(collectionView)
    }
    
    
    func setCollectionViewRegister(_ collectionView: UICollectionView) {
        collectionView.register(HomeFilterCell.self, forCellWithReuseIdentifier: "HomeFilterCell")
        collectionView.register(HomeCategoryCell.self, forCellWithReuseIdentifier: "HomeCategoryCell")
        collectionView.register(HomeCountryCategoryCell.self, forCellWithReuseIdentifier: "HomeCountryCategoryCell")
        collectionView.register(HomeUserPostCell.self, forCellWithReuseIdentifier: "HomeUserPostCell")
        collectionView.register(HomeRecruitUserCell.self, forCellWithReuseIdentifier: "HomeRecruitUserCell")
        
        collectionView.register(HomeSearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSearchHeaderView")
        collectionView.register(HomeCategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCategoryHeaderView")
        collectionView.register(HomeCountryCategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCountryCategoryHeaderView")
        collectionView.register(HomeUserPostHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeUserPostHeaderView")
        collectionView.register(HomeRecruitHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeRecruitHeaderView")
    }
}




extension HomeController {
    
    fileprivate func setFilterLayout() -> NSCollectionLayoutSection {
        
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let headerSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )
        
        let header: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [header]
        
        
        return section
    }
    
    fileprivate func setCategoryLayout() -> NSCollectionLayoutSection {
        
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100),
            heightDimension: .absolute(100)
        )
        
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 5, bottom: 10, trailing: 5)
        
        let headerSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        
        
        let header: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        
        
        return section
    }
    
    
    fileprivate func setCountryProjectLayout() -> NSCollectionLayoutSection {
        
        
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .absolute(300)
        )
        
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        
        let headerSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        
        let header: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(300)
        )
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    
    fileprivate func setUserPostLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(180)
        )
        
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let headerSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        
        let header: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200)
        )
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    
    fileprivate func setRecruitUserSection() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100)
            , heightDimension: .absolute(150)
        )
        
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        
        let headerSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        
        let header: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(view.frame.size.width),
            heightDimension: .absolute(150)
        )
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}


//MARK: Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        reactor?.action
//            .map{ _ in Reactor.Action.didScroll}
//            .bind(to: reactor!.action)
//            .disposed(by: disposeBag)
//
//        reactor?.state
//            .map { !$0.isScroll}
//            .observe(on: MainScheduler.instance)
//            .bind(to: self.floatingButton.rx.isHidden)
//            .disposed(by: disposeBag)
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        reactor?.action
//            .map { _ in Reactor.Action.didEndScroll}
//            .bind(to: reactor!.action)
//            .disposed(by: disposeBag)
//
//        reactor?.state
//            .map { $0.isScroll}
//            .observe(on: MainScheduler.instance)
//            .bind(to: self.floatingButton.rx.isHidden)
//            .disposed(by: disposeBag)
//    }




extension HomeController: ReactorKit.View {
    
    typealias Reactor = HomeViewReactor
    
    func bind(reactor: Reactor) {
        
    }
    
    
}
