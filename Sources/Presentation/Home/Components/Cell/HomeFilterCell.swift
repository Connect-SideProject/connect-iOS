//
//  HomeFilterCell.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit


final class HomeFilterCell: UICollectionViewCell  {
    
    private let filterButton: UIButton = {
        
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitleColor(.black, for: .normal)
        
        return $0
    }(UIButton())
    
    private let filterView: UIView = {
        $0.backgroundColor = .black
        return $0
    }(UIView(frame: .zero))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure()  {
        _ = [filterButton,filterButton].map { contentView.addSubview($0)}
        
        filterButton.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        
        filterButton.snp.makeConstraints {
            $0.top.equalTo(filterButton.snp.bottom)
            $0.left.right.equalTo(filterButton)
            $0.height.equalTo(2)
        }
    }
    
}
