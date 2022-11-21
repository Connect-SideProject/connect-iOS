//
//  SearchViewController.swift
//  App
//
//  Created by Kim dohyun on 2022/11/21.
//

import UIKit
import Then
import SnapKit
import ReactorKit

import RxDataSources




/// 프로젝트 검색 화면 컨트롤러
final class SearchViewController: UIViewController {
    
    //MARK: Property
    
    private let searchTableView: UITableView = UITableView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .hexEDEDED
        $0.register(SearchStudyListCell.self, forCellReuseIdentifier: "SearchStudyListCell")
    }
    
    private lazy var searchDataSource: RxTableViewSectionedReloadDataSource<SearchSection> = .init(configureCell: { dataSource, tableView, indexPath, sectionItem in
        guard let searchListCell = tableView.dequeueReusableCell(withIdentifier: "SearchStudyListCell", for: indexPath) as? SearchStudyListCell else { return UITableViewCell() }
        return searchListCell
    })
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Configure
    private func configure() {
        
    }
    
    
    
}
