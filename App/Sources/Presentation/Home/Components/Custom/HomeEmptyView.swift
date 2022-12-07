//
//  HomeEmptyView.swift
//  App
//
//  Created by Kim dohyun on 2022/12/07.
//

import UIKit
import SnapKit

import COManager


final class HomeEmptyView: BaseView {
    
    //MARK: Property
    
    private let emptyContainerView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    private let emptyImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_empty_search")
    }
    
    private let emptyInfoLabel: UILabel = UILabel().then {
        $0.textColor = .hex5B5B5B
        $0.font = .regular(size: 12)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    private func configure() {
        
        _ = [emptyImageView,emptyInfoLabel].map {
            emptyContainerView.addSubview($0)
        }
        
        self.addSubview(emptyContainerView)
        
        guard let region = UserManager.shared.profile?.region?.description else { return }
        
        emptyInfoLabel.text = "\(region)애는 게시글이 없어요\n 더 많은 정보를 보려면 마이페이지에서 활동지역을 바꿔보세요"
        
        emptyContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(57)
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        emptyInfoLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().offset(-19)
            $0.centerX.equalTo(emptyImageView)
        }
        
        
    }
    
    
    
}
