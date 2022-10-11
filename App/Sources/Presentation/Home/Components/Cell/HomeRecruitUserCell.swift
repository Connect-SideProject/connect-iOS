//
//  HomeRecruitUserCell.swift
//  connect
//
//  Created by Kim dohyun on 2022/06/10.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

/// 홈 사용자 모집 셀
final class HomeRecruitUserCell: UICollectionViewCell {
    
    //MARK: Property
    private let userProfileImageView: UIImageView = {
        $0.image = UIImage()
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.layer.masksToBounds = true
        
        return $0
    }(UIImageView())
    
    
    private let userNameLabel: UILabel = {
        $0.text = "김도현"
        $0.font = .systemFont(ofSize: 14, weight: UIFont.Weight(1.0))
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let userCareerLabel: UILabel = {
        $0.text = "개발자"
        $0.font = .systemFont(ofSize: 9)
        $0.textColor = .lightGray
        $0.numberOfLines = 1
        $0.textAlignment = .center
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
        
        [userProfileImageView,userNameLabel,userCareerLabel].forEach {
            contentView.addSubview($0)
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(10)
            $0.centerX.equalTo(userProfileImageView)
            $0.width.lessThanOrEqualTo(userProfileImageView.snp.width)
            $0.height.equalTo(20)
        }
        
        userCareerLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(userNameLabel)
            $0.width.equalTo(30)
            $0.height.equalTo(20)
        }
        
        contentView.backgroundColor = .white
        
    }
    
}
