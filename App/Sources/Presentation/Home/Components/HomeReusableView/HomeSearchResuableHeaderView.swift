//
//  HomeSearchResuableHeaderView.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/10/03.
//

import UIKit
import Then
import SnapKit
import COCommonUI

import RxGesture
import RxSwift


final class HomeSearchResuableHeaderView: UICollectionReusableView {
    
    public var completion: (() -> Void)?
    
    //MARK: Property
    private let homeSearchView: HomeSearchView = HomeSearchView().then {
        $0.layer.borderColor = UIColor.hexF9F9F9.cgColor
        $0.layer.borderWidth = 2
    }
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    private func configure() {
        
        self.addSubview(homeSearchView)
        
        homeSearchView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        homeSearchView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind { _ in
                self.completion?()
            }.disposed(by: disposeBag)
    }
    
    
}


