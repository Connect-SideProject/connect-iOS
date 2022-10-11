//
//  HomeCategoryHeaderView.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/04.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit


/// 홈 카테고리 헤더 뷰
final class HomeCategoryHeaderView: UICollectionReusableView {
    
    //MARK: Property
    
    private var titleLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = "인기 관심 분야 Top 3"
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .black
        
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
        
        titleLabel.attributedText = NSAttributedString(string: titleLabel.text!)
            .setAttributed(key: .foregroundColor,
                      value: UIColor.systemPink,
                      compare: "Top 3")
            
        titleLabel.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        
    }
    
    
}
