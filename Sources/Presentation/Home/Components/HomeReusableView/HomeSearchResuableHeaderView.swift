//
//  HomeSearchResuableHeaderView.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/10/03.
//

import UIKit
import SnapKit


final class HomeSearchResuableHeaderView: UICollectionReusableView {
    
    //MARK: Property
    private let homeSearchView: HomeSearchView = HomeSearchView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    private func configure() {
        
        self.addSubview(homeSearchView)
        
        homeSearchView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }
    
    
}


