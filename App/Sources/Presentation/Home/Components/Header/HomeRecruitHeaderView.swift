//
//  HomeRecruitHeaderView.swift
//  connect
//
//  Created by Kim dohyun on 2022/06/10.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

/// 홈 사용자 모집 헤더 뷰
final class HomeRecruitHeaderView: UICollectionReusableView {
    
    
    //MARK: Property
    private let recruitLabel: UILabel = {
        $0.text = "모집 중인 커넥터"
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
        $0.numberOfLines = 1
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
        addSubview(recruitLabel)
        
        recruitLabel.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.width.lessThanOrEqualTo(150)
        }
    }
    
}
