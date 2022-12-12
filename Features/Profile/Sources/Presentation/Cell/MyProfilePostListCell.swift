//
//  MyProfilePostListCell.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/11.
//

import UIKit
import SnapKit
import ReactorKit

import COManager




final class MyProfilePostListCell: UICollectionViewCell {
    
    //MARK: Property
    
    typealias Reactor = MyProfilePostListCellReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let profilePostContainerView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
        $0.layer.borderColor = UIColor.hexEDEDED.cgColor
    }
    
    private let profilePostStateView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
    }
    
    private let profilePostStateLabel: UILabel = UILabel().then {
        $0.font = .medium(size: 11)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private let profilePostTitleLabel: UILabel = UILabel().then {
        $0.font = .semiBold(size: 16)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let profilePostSubTitleLabel: UILabel = UILabel().then {
        $0.font = .regular(size: 14)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    
    private let profilePostMemberStateLabel: UILabel = UILabel().then {
        $0.textColor = .hex8E8E8E
        $0.font = .regular(size: 12)
        $0.textAlignment = .left
    }
    
    private let profilePostMemberImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_member")
    }
    
    private let profilePostBookMarkView: UIView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let profilePostBookMarkImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_bookmark")
    }
    
    
    
    
    //MARK: initalization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
    
    //MARK: Configure
    
    private func configure() {
        
        profilePostStateView.addSubview(profilePostStateLabel)
        profilePostBookMarkView.addSubview(profilePostBookMarkImageView)
        
        self.contentView.addSubview(profilePostContainerView)
        
        _ = [profilePostStateView, profilePostTitleLabel, profilePostSubTitleLabel, profilePostMemberImageView,
             profilePostStateLabel, profilePostBookMarkView
        ].map {
            profilePostContainerView.addSubview($0)
        }
        
        profilePostContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profilePostStateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(18)
        }
        
        profilePostStateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
        
        profilePostBookMarkView.snp.makeConstraints {
            $0.top.equalTo(profilePostStateView)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
        
        profilePostBookMarkImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profilePostSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profilePostStateView.snp.bottom).offset(8)
            $0.left.equalTo(profilePostStateView)
            $0.right.equalToSuperview().offset(-16)
        }
        
        profilePostTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profilePostStateView)
            $0.left.equalTo(profilePostStateView
                .snp.right).offset(10)
            $0.height.equalTo(19)
        }
        
        profilePostMemberImageView.snp.makeConstraints {
            $0.left.equalTo(profilePostStateView)
            $0.height.width.equalTo(16)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        
        
    }
    
}



extension MyProfilePostListCell: ReactorKit.View {
    func bind(reactor: Reactor) {
        
        
        
        
    }
}
