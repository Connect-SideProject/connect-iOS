//
//  HomeStudyListCell.swift
//  connect
//
//  Created by Kim dohyun on 2022/10/06.
//

import UIKit
import Then
import SnapKit



final class HomeStudyListCell: UICollectionViewCell {
    
    //MARK: Property
    private let studyListContainerView: UIView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
    }
    
    private let studyListStateView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
    }
    
    private let studyListStateLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = UIColor.white
        
    }
    
    private let studyListTitleLabel: UILabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let studyListSubTitleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let studyMemberStateLabel: UILabel = UILabel().then {
        $0.textColor = .gray04
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textAlignment = .left
    }
    
    private let studyMemberImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_member")
    }
    
    private let studyBookMarkView: UIView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let studyBookMarkImageView: UIImageView = UIImageView().then {
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

        studyListStateView.addSubview(studyListStateLabel)
        studyBookMarkView.addSubview(studyBookMarkImageView)
        
        self.contentView.addSubview(studyListContainerView)
        
        _ = [studyListStateView,studyListTitleLabel,studyListSubTitleLabel,studyMemberImageView,studyMemberStateLabel,studyBookMarkView].map {
            studyListContainerView.addSubview($0)
        }
        
        
        studyListContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyListStateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(18)
            $0.centerY.equalToSuperview()
        }
        
        studyListStateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.width.equalTo(30)
            $0.height.equalTo(12)
            $0.center.equalToSuperview()
        }
        
        studyListTitleLabel.snp.makeConstraints {
            $0.top.equalTo(studyListStateLabel)
            $0.left.equalTo(studyListStateView.snp.right).offset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(19)
        }
        
        studyBookMarkView.snp.makeConstraints {
            $0.top.equalTo(studyListStateView)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
        
        studyBookMarkImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyListSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(studyListStateView.snp.bottom).offset(8)
            $0.left.equalTo(studyListStateView)
            $0.height.equalTo(17)
            $0.centerY.equalToSuperview()
        }
        
        studyMemberImageView.snp.makeConstraints {
            $0.left.equalTo(studyListStateView)
            $0.height.width.equalTo(16)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        studyMemberStateLabel.snp.makeConstraints {
            $0.left.equalTo(studyMemberImageView.snp.right).offset(5)
            $0.height.equalTo(14)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    
}
