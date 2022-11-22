//
//  SearchViewController.swift
//  App
//
//  Created by Kim dohyun on 2022/11/21.
//

import UIKit
import Then
import ReactorKit
import COCommonUI

import RxDataSources




/// 프로젝트 검색 화면 컨트롤러
public final class SearchViewController: UIViewController {
    
    //MARK: Property
    
    public typealias Reactor = SearchViewReactor
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var collectionViewLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    private lazy var keywordCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout).then {
        $0.register(SearchKeywordListCell.self, forCellWithReuseIdentifier: "SearchKeywordListCell")
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
    }

    private lazy var searchDataSource: RxCollectionViewSectionedReloadDataSource<SearchSection> = .init(configureCell: { datasource, collectionView, indexPath, sectionItem in
        guard let searchKeywordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchKeywordListCell", for: indexPath) as? SearchKeywordListCell else { return UICollectionViewCell() }
    })
    
    
    private lazy var keywordSearchController: UISearchController = UISearchController().then {
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.placeholder = "찾는 프로젝트 키워드를 검색해보세요."
    }
    
    private let keywordIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.backgroundColor = .clear
    }
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
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
        configure()
    }
    
    //MARK: Configure
    private func configure() {
        
        _ = [keywordIndicatorView,keywordCollectionView].map {
            self.view.addSubview($0)
        }
        
        keywordCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        keywordIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(12)
        }
        
        
        self.navigationItem.searchController = keywordSearchController
        
        
    }
    
    
    
}



extension SearchViewController: ReactorKit.View {
    
    
    public func bind(reactor: Reactor) {
        
    }
    
    
}
