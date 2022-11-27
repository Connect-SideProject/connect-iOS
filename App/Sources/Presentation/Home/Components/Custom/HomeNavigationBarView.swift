//
//  HomeNavigationBarView.swift
//  App
//
//  Created by Kim dohyun on 2022/10/31.
//

import UIKit
import Then
import COManager
import SnapKit


final class HomeNavigationBarView: BaseView {
    
    //MARK: Property
    private let locationContainerView: UIView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let notificationContainerView: UIView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    
    private let locationImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "home_top_location")
        $0.contentMode = .scaleToFill
    }
    
    private let locationLabel: UILabel = UILabel().then {
        $0.font = .regular(size: 16)
        $0.textColor = .hex3A3A3A
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let notificationImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "home_top_notification_disable-1")
        $0.contentMode = .scaleToFill
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        self.backgroundColor = .white
        
        guard let mylocationText = UserManager.shared.profile?.region?.description else { return }
        
        
        self.notificationContainerView.addSubview(notificationImageView)
        self.locationLabel.text = mylocationText
        
        _ = [locationLabel, locationImageView].map {
            locationContainerView.addSubview($0)
        }
        
        _ = [locationContainerView, notificationContainerView].map {
            self.addSubview($0)
        }
        
        locationImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        locationLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.left.equalTo(locationImageView.snp.right).offset(8)
            $0.centerY.equalTo(locationImageView)
        }
        
        locationContainerView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(13)
            $0.centerY.equalToSuperview()
        }
        
        notificationImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        notificationContainerView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.right.equalToSuperview().offset(-21)
            $0.top.equalTo(locationContainerView)
        }
    }
    
    
    
    
}




