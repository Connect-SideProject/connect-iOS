//
//  NoticeTableViewCell.swift
//  App
//
//  Created by Kim dohyun on 2022/12/04.
//

import UIKit
import Then
import SnapKit


final class NoticeTableViewCell: UITableViewCell {
    
    //MARK: Property
    
    private let noticeImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let noticeTitleLabel: UILabel = UILabel().then {
        $0.font = .regular(size: 16)
        $0.textColor = .hex000000
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    private let noticeDateToLable: UILabel = UILabel().then {
        $0.font = .regular(size: 12)
        $0.textColor = .hex8E8E8E
        $0.numberOfLines = 1
        $0.textAlignment = .left
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
    
    private func configure(){
        
        _ = [noticeImageView, noticeTitleLabel, noticeDateToLable].map {
            self.contentView.addSubview($0)
        }
        
        noticeImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
        }
        
        noticeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(noticeImageView.snp.top)
            $0.left.equalTo(noticeImageView.snp.right).offset(16)
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(noticeImageView)
        }
        
        noticeDateToLable.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(4)
            $0.left.equalTo(noticeTitleLabel)
            $0.height.equalTo(14)
            
        }
    }
    
    
}
