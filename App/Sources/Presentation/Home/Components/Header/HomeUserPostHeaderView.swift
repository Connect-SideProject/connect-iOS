//
//  HomeUserPostHeaderView.swift
//  connect
//
//  Created by Kim dohyun on 2022/06/05.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

/// 홈 실시간 HOT 게시글 헤더 뷰
final class HomeUserPostHeaderView: UICollectionReusableView {
    
    //MARK: Property
    private var titleLabel: UILabel = {
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.text = "실시간 HOT 게시글"
        $0.font = .boldSystemFont(ofSize: 20)
        
        return $0
    }(UILabel())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Configure
    
    private func configure() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}
