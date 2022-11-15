//
//  HomeStudyListFooterView.swift
//  connect
//
//  Created by Kim dohyun on 2022/10/06.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa


final class HomeStudyListFooterView: UICollectionReusableView {
    
    //MARK: Property
        
    private let studyMoreButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.hex8E8E8E, for: .normal)
        $0.setImage(UIImage(named: "home_studylist_more"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
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
        
        self.addSubview(studyMoreButton)
        
        studyMoreButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    
    
    
}
