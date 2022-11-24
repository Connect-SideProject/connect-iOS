//
//  HomeSearchHeaderView.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import Then
import COCommonUI

final class HomeSearchHeaderView: UICollectionReusableView {
    
    
    //MARK: Property
    
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.text = "어떤 프로젝트를 찾으시나요?"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .left
    
    }
    
    private let searchView: HomeSearchView = HomeSearchView().then {
        $0.layer.borderColor = UIColor.hexF9F9F9.cgColor
        $0.layer.borderWidth = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        debugPrint(#function)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func configure() {
        
        _ = [mainTitleLabel,searchView].map { addSubview($0) }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.left.equalToSuperview().offset(19)
            $0.width.lessThanOrEqualTo(200)
        }
        
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(11)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(42)
            
        }
        
    }
    
}
