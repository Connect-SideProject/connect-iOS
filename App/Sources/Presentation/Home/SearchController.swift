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
public final class SearchController: UIViewController {
    
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
        
        switch sectionItem {
        
    case let .searchList(cellReactor):
        guard let searchKeywordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchKeywordListCell", for: indexPath) as? SearchKeywordListCell else { return UICollectionViewCell() }
        searchKeywordCell.reactor = cellReactor
    }
        return UICollectionViewCell()
})
    
    
    private let keywordSearchBar: UISearchBar = UISearchBar().then {
        let attributed = NSAttributedString(string: "찾는 프로젝트 키워드를 검색해보세요.", attributes: [
            NSAttributedString.Key.font: UIFont.regular(size: 14),
            NSAttributedString.Key.foregroundColor: UIColor.hexC6C6C6
        ])
        
        $0.showsCancelButton = false
        $0.searchTextField.attributedPlaceholder = attributed
        $0.searchBarStyle = .minimal
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
        self.view.backgroundColor = .white
        _ = [keywordIndicatorView,keywordSearchBar,keywordCollectionView].map {
            self.view.addSubview($0)
        }
        
        
        keywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(keywordSearchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        
        keywordSearchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(44)
        }
        
        
        keywordIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(12)
        }
        
        
    }
    
    
    
}



extension SearchController: ReactorKit.View {
    
    
    public func bind(reactor: Reactor) {
        
        
        self.keywordCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isLoading }
            .observe(on: MainScheduler.instance)
            .bind(to: keywordIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.section }
            .debug("Search Keywrod Section")
            .observe(on: MainScheduler.instance)
            .bind(to: keywordCollectionView.rx.items(dataSource: self.searchDataSource))
            .disposed(by: disposeBag)
        
        
        
    }
    
    
}



extension SearchController: UICollectionViewDelegateFlowLayout {
    
    
    
}
