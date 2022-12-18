//
//  HomeStudyMenuFooterView.swift
//  connect
//
//  Created by Kim dohyun on 2022/10/06.
//

import UIKit
import Then
import SnapKit


final class HomeStudyMenuFooterView: UICollectionReusableView {
    
    
    //MARK: Property
    private let homeMenuLineView: UIView = UIView().then {
        $0.backgroundColor = .hexEDEDED
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    private func configure() {
        self.addSubview(homeMenuLineView)
        
        homeMenuLineView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
