//
//  HomeStudyListFooterView.swift
//  connect
//
//  Created by Kim dohyun on 2022/10/06.
//

import UIKit
import Then
import SnapKit


final class HomeStudyListFooterView: UICollectionReusableView {
    
    //MARK: Property
    private let studyMoreContainerView: UIView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let studyMoreLabel: UILabel = UILabel().then {
        $0.text = "더보기"
        $0.textColor = .gray04
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    private let studyMoreImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_more")
        
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
        self.addSubview(studyMoreContainerView)
        
        _ = [studyMoreLabel,studyMoreImageView].map {
            studyMoreContainerView.addSubview($0)
        }
        
        studyMoreContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyMoreLabel.snp.makeConstraints {
            $0.width.equalTo(42)
            $0.height.equalTo(16)
            $0.center.equalToSuperview()
        }
        
        studyMoreImageView.snp.makeConstraints {
            $0.left.equalTo(studyMoreLabel.snp.right).offset(5)
            $0.width.height.equalTo(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    
    
    
    
}
