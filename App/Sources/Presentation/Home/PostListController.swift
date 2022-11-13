//
//  PostListController.swift
//  connect
//
//  Created by Kim dohyun on 2022/06/12.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxDataSources


/// 프로젝트 리스트 화면 컨트롤러
final class PostListController: UIViewController {
    
    //MARK: Property
    
    private let postListIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.backgroundColor = .clear
    }
    
    
    private let postTableView: UITableView = UITableView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .white
        $0.register(PostStduyListCell.self, forCellReuseIdentifier: "PostStduyListCell")
    }
    
    private let postDataSource: RxTableViewSectionedReloadDataSource<PostSection>
    
    private static func postSourceFactory() -> RxTableViewSectionedReloadDataSource<PostSection> {
        return .init(configureCell: { dataSource, tableView, indexPath, sectionItem in
            guard let postListCell = tableView.dequeueReusableCell(withIdentifier: "PostStduyListCell", for: indexPath) as? PostStduyListCell else { return UITableViewCell() }
            return postListCell
        })
    }
    
    
    
    init() {
        self.postDataSource = type(of: self).postSourceFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Configure
    
    private func configure(){
        
        _ = [postListIndicatorView, postTableView].map {
            self.view.addSubview($0)
        }
        
        postListIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        postTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    
}
