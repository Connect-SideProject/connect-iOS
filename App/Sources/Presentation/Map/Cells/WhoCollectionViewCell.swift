//
//  StudyCollectionViewCell.swift
//  connect
//
//  Created by 이건준 on 2022/07/26.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

protocol WhoCollectionViewCellDelegate: AnyObject {
    func didTappedProfileButton()
}

class WhoCollectionViewCell: UICollectionViewCell {
    
//    static let identifier = "WhoCollectionViewCell"
    
    weak var delegate: WhoCollectionViewCellDelegate?
    
    private let nameLabel: UnderlineLabel = {
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.highlightedTextColor = .black
        $0.textAlignment = .left
//        $0.text = "익명의 커넥터"
        return $0
    }(UnderlineLabel())
    
    private let profileImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let chattingButton: UIButton = {
        $0.setTitle("채팅하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.backgroundColor = .purple
        $0.titleLabel?.font = .systemFont(ofSize: 13)
        return $0
    }(UIButton())
    
    private let profileButton: UIButton = {
        $0.setTitle("프로필", for: .normal)
        $0.setTitleColor(UIColor.purple, for: .normal)
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.purple.cgColor
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .systemFont(ofSize: 13)
        return $0
    }(UIButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        profileImageView.image = nil
        chattingButton.setTitle(nil, for: .normal)
        chattingButton.backgroundColor = nil
        chattingButton.layer.borderWidth = 0
        profileButton.setTitle(nil, for: .normal)
        profileButton.backgroundColor = nil
        profileButton.layer.borderWidth = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(50)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
        
        chattingButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo((contentView.frame.width - 15) / 2)
        }
        
        profileButton.snp.makeConstraints { make in
            make.centerY.equalTo(chattingButton.snp.centerY)
            make.right.bottom.equalToSuperview().offset(-5)
            make.left.equalTo(chattingButton.snp.right).offset(5)
            make.width.equalTo((contentView.frame.width - 15) / 2)
        }
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        [nameLabel, profileImageView, chattingButton, profileButton].forEach{contentView.addSubview($0)}
        
        profileButton.addTarget(self, action: #selector(didTappedProfileButton), for: .touchUpInside)
    }
    
    public func configureUI(with model: String) {
        // MOCK
        nameLabel.text = "익명의 커넥터"
        profileImageView.image = UIImage(systemName: "heart.fill")
        chattingButton.setTitle("채팅하기", for: .normal)
        chattingButton.backgroundColor = .purple
        chattingButton.layer.borderWidth = 1
        chattingButton.layer.borderColor = UIColor.purple.cgColor
        profileButton.setTitle("프로필", for: .normal)
        profileButton.backgroundColor = .white
        profileButton.layer.borderWidth = 1
    }
    
    @objc private func didTappedProfileButton() {
        delegate?.didTappedProfileButton()
    }
}
