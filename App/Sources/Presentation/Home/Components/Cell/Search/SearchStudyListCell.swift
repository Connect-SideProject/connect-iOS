//
//  SearchStudyListCell.swift
//  App
//
//  Created by Kim dohyun on 2022/11/21.
//


import UIKit
import Then
import SnapKit


final class SearchStudyListCell: UITableViewCell {
    
    //MARK: Property
    
    private let searchContainerView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
        $0.layer.borderColor = UIColor.hexEDEDED.cgColor
        $0.layer.borderWidth = 1
    }
    
    
    private let searchStateView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 2
    }
    
    private let searchStateTitleLabel: UILabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.sizeToFit()
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    private let searchTitleLabel: UILabel = UILabel().then {
        $0.textColor = .hex141616
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let searchExplanationLabel: UILabel = UILabel().then {
        $0.textColor = .hex141616
        $0.font = .regular(size: 14)
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let searchBookMarkContainerView: UIView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let searchBookMarkImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "home_studylist_bookmark")
        $0.contentMode = .scaleToFill
    }
    
    private let searchMemberImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "home_studylist_member")
        $0.contentMode = .scaleToFill
    }
    
    private let searchMemberLabel: UILabel = UILabel().then {
        $0.font = .regular(size: 12)
        $0.textAlignment = .left
        $0.textColor = .hex8E8E8E
        $0.sizeToFit()
    }
    
    
    
    //MARK: initalization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    
    private func configure() {
        searchStateView.addSubview(searchStateTitleLabel)
        searchBookMarkContainerView.addSubview(searchBookMarkImageView)
        
        self.contentView.addSubview(searchContainerView)
        
        
        _ = [searchStateView, searchTitleLabel, searchExplanationLabel, searchMemberImageView, searchMemberLabel, searchBookMarkContainerView].map {
            searchContainerView.addSubview($0)
        }
        
        searchContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchStateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(18)
            $0.centerY.equalToSuperview()
        }
        
        searchStateTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.width.equalTo(30)
            $0.height.equalTo(12)
            $0.center.equalToSuperview()
        }
        
        searchTitleLabel.snp.makeConstraints {
            $0.top.equalTo(searchStateView)
            $0.left.equalTo(searchStateView.snp.right).offset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(19)
        }
        
        searchBookMarkContainerView.snp.makeConstraints {
            $0.top.equalTo(searchStateView)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
        
        searchBookMarkImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchExplanationLabel.snp.makeConstraints {
            $0.top.equalTo(searchStateView.snp.bottom).offset(8)
            $0.left.equalTo(searchStateView)
            $0.height.equalTo(17)
            $0.centerY.equalToSuperview()
        }
        
        searchMemberImageView.snp.makeConstraints {
            $0.left.equalTo(searchStateView)
            $0.height.width.equalTo(16)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        searchMemberLabel.snp.makeConstraints {
            $0.left.equalTo(searchMemberLabel.snp.right).offset(5)
            $0.height.equalTo(14)
            $0.centerY.equalToSuperview()
        }
        
        
        
    }
    
    
}
