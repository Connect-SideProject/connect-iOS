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
    
    private let searchView: HomeSearchView = HomeSearchView()
    
    
    
    let datasources: RxCollectionViewSectionedReloadDataSource<HomeViewSection>
    
        private lazy var collectionView: UICollectionView = {
        
            let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    
    static func dataSourcesFactory() -> RxCollectionViewSectionedReloadDataSource<HomeViewSection> {
        return .init { datasource, collectionView, indexPath, sectionItem in
            switch sectionItem {
            case let .field(reactor):
                let fieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as? HomeCategoryCell
                fieldCell?.reactor = reactor
                return fieldCell!
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
        [collectionView,floatingButton].forEach {
            view.addSubview($0)
        }
        
        collectionView.addSubview(searchView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchView.snp.makeConstraints {
            $0.right.equalTo(self.view).offset(-20)
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(12)
            $0.height.equalTo(44)
        }
        
        floatingButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-15)
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



extension HomeController: ReactorKit.View {
    
    typealias Reactor = HomeViewReactor
    
    func bind(reactor: Reactor) {
        
    }
    
    
}
