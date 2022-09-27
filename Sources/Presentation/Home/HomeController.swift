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
final class HomeController: UIViewController {
    
    //MARK: Property
    
    typealias Reactor = HomeViewReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    
    private let floatingButton: UIButton = UIButton().then {
        $0.backgroundColor = UIColor.white
        $0.layer.masksToBounds = false
        $0.setImage(UIImage(named: "home_search_floating"), for: .normal)
    }
    
    private let searchView: HomeSearchView = HomeSearchView()
    
    
    
    let dataSource: RxCollectionViewSectionedReloadDataSource<HomeViewSection>
    
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.register(HomeCategoryCell.self, forCellWithReuseIdentifier: "HomeCategoryCell")
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        
    }


    
    
    
    private static func dataSourcesFactory() -> RxCollectionViewSectionedReloadDataSource<HomeViewSection> {
        return .init(
        configureCell: { datasource, collectionView, indexPath, sectionItem in
            print("Section Item : \(sectionItem)")
            switch sectionItem {
            case let .homeMenu(cellReactor):
                
                guard let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as? HomeCategoryCell else { return UICollectionViewCell() }
                
                menuCell.reactor = cellReactor
                return menuCell
                
                
            default:
                return UICollectionViewCell()
            }
        }
    )}
    
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
        
        

    }

}



extension HomeController: ReactorKit.View {
    
    func bind(reactor: Reactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bindCollectionView(reactor: reactor)
        
        
    }
    
    
}

extension HomeController {
    func bindCollectionView(reactor: Reactor) {
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        print("Datasource Check : \(self.dataSource)")
        
        reactor.state
            .map { $0.section }
            .observe(on: MainScheduler.instance)
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
    }
}



extension HomeController: UICollectionViewDelegateFlowLayout {
    

}

