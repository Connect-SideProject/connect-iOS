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
final class SearchViewController: UIViewController {
    
    //MARK: Property
    
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
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Configure
    private func configure() {
        
        keywordCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    
}
