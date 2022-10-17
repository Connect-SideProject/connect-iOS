//
//  HomeCountryCategoryHeaderView.swift
//  connect
//
//  Created by Kim dohyun on 2022/06/05.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit


/// 홈 지역 카테고리 헤더 뷰
final class HomeCountryCategoryHeaderView: UICollectionReusableView {
    
    //MARK: Property
    public var country: String = "" {
        didSet {
            self.titleLabel.text = "\(country)에서 진행중인 프로젝트"
        }
    }
    
    private var titleLabel: UILabel = {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 1
        
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
    }
}
