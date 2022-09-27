//
//  HomeStudyMenuCell.swift
//  connect
//
//  Created by Kim dohyun on 2022/09/28.
//

import UIKit
import SnapKit
import Then


final class HomeStudyMenuCell: UICollectionViewCell {
    
    //MARK: Property
    private let studyMenuButton: UIButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.titleLabel?.textColor = .black
    }
    
    
    //MARK: initalization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print(#function)
    }
    
    
    //MARK: Configure
    private func configure() {
        self.contentView.addSubview(studyMenuButton)
        
        studyMenuButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    
}
