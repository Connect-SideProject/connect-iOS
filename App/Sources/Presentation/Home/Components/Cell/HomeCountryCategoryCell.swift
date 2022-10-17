//
//  HomeCountryCategoryCell.swift
//  connect
//
//  Created by Kim dohyun on 2022/06/05.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit


/// 홈 지역 프로젝트 카테고리 셀
final class HomeCountryCategoryCell: UICollectionViewCell {
    
    //MARK: Property
    private var titleLabel: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
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
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .black
        
        titleLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview()
        }
    }
    
}
