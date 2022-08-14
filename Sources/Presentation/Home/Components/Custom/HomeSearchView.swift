//
//  HomeSearchView.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation
import UIKit
import RxSwift



final class HomeSearchView: BaseView {
    
    //MARK: Property
    private let placeHolderLabel: UILabel = {
        $0.textColor = UIColor.gray01
        $0.numberOfLines = 1
        
        return $0
    }(UILabel())
    
     
    private let searchImageView: UIImageView = {
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
                
        _ = [searchImageView,placeHolderLabel].map {
            addSubview($0)
        }
        
        searchImageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        placeHolderLabel.snp.makeConstraints {
            $0.centerY.equalTo(searchImageView)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(searchImageView.snp.right)
        }
    }
    
    
}








