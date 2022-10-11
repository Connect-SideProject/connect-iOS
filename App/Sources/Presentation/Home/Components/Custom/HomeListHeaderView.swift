//
//  HomeListHeaderView.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/07/11.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

/// 홈 카테고리 리스트 뷰
final class HomeListHeaderView: UIView {
    
    //MARK:
    private let allButton: UIButton = {
        $0.setTitle("전체", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
        return $0
    }(UIButton())
    
    private let projectButton: UIButton = {
        $0.setTitle("프로젝트", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
        return $0
    }(UIButton())
    
    private let studyButton: UIButton = {
        $0.setTitle("스터디", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
        
        return $0
    }(UIButton())
    
    private let stickView: UIView = {
        $0.backgroundColor = .black
        return $0
    }(UIView())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Configure
    private func configure() {
        backgroundColor = .white
        [allButton,projectButton,studyButton,stickView].forEach {
            addSubview($0)
        }
        
        allButton.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.equalTo(100)
            $0.bottom.equalTo(-5)
        }
        
        projectButton.snp.makeConstraints {
            $0.centerY.equalTo(allButton)
            $0.width.equalTo(100)
            $0.left.equalTo(allButton.snp.right)
            $0.bottom.equalTo(-5)
        }
        
        studyButton.snp.makeConstraints {
            $0.centerY.equalTo(allButton)
            $0.width.equalTo(100)
            $0.left.equalTo(projectButton.snp.right)
            $0.bottom.equalTo(-5)
        }
        
        stickView.snp.makeConstraints {
            $0.top.equalTo(allButton.snp.bottom)
            $0.left.bottom.equalToSuperview()
            $0.right.equalTo(allButton.snp.right)
        }
    }
    
}

