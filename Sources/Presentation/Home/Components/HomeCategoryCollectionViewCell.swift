//
//  HomeCategoryCollectionViewCell.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/04.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit


/// 홈 카테고리 셀
final class HomeCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: Property
    
    private var titleLabel: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 9)
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
        contentView.backgroundColor = .white
    }
    
}
