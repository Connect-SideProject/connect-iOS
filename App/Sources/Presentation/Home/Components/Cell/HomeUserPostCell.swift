//
//  HomeUserPostCell.swift
//  connect
//
//  Created by Kim dohyun on 2022/06/05.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

/// 홈 실시간 HOT 게시글
final class HomeUserPostCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
