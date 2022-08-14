//
//  HomeSearchView.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit



final class HomeSearchView: BaseView {
    
    //MARK: Property
    private let placeHolderLabel: UILabel = {
        $0.textColor = UIColor.gray03
        $0.numberOfLines = 1
        $0.text = "찾는 프로젝트 키워드를 검색해보세요."
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return $0
    }(UILabel())
    

    private let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = .black
        
        return $0
    }(UIImageView())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func configure()  {
        self.layer.borderColor = UIColor.gray03.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        
                
        _ = [imageView,placeHolderLabel].map {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        placeHolderLabel.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(imageView.snp.right).offset(5)
        }
    }
    
    
}








