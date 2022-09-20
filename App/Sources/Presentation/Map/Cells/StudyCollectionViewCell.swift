//
//  StudyCollectionViewCell.swift
//  connect
//
//  Created by 이건준 on 2022/06/28.
//  Copyright © 2022 sideproj. All rights reserved.
//

import SnapKit
import UIKit

protocol StudyCollectionViewCellDelegate: AnyObject {
    func didTappedChattingButton()
    func didTappedMoreButton()
}

class StudyCollectionViewCell: UICollectionViewCell {
    
//    static let identifer = "StudyCollectionViewCell"
    
    weak var delegate: StudyCollectionViewCellDelegate?
    
    private let studyTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let studyDescriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 3
        return label
    }()
    
    private let studyBookmarkButton: UIButton = {
       let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "bookmark", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let chattingButton: UIButton = {
       let button = UIButton()
        button.setTitle("담당자와 채팅하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.titleLabel?.textAlignment = .center
//        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.setTitle("더보기 >", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.titleLabel?.textAlignment = .center
//        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.clipsToBounds = true
        button.backgroundColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        studyTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(contentView.frame.width - 60)
        }
        
        studyBookmarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(studyTitleLabel.snp.centerY)
            make.left.equalTo(studyTitleLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        studyDescriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(studyTitleLabel.snp.bottom).offset(10)
        }
        
        chattingButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(40)
            make.width.equalTo((contentView.frame.width - 15) * 2 / 3)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(chattingButton.snp.centerY)
            make.left.equalTo(chattingButton.snp.right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(40)
//            make.width.equalTo(100)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        studyTitleLabel.text = nil
        studyDescriptionLabel.text = nil
        studyBookmarkButton.setImage(nil, for: .normal)
        studyBookmarkButton.backgroundColor = nil
        chattingButton.setTitle(nil, for: .normal)
        chattingButton.backgroundColor = nil
        chattingButton.layer.borderWidth = 0
        moreButton.setTitle(nil, for: .normal)
        moreButton.backgroundColor = nil
        moreButton.layer.borderWidth = 0
    }
    
    // MARK: -Action
    @objc private func didTappdChattingButton() {
        delegate?.didTappedChattingButton()
    }
    
    @objc private func didTappdMoreButton() {
        delegate?.didTappedMoreButton()
    }
    
    // MARK: -Configure
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        [studyTitleLabel, studyDescriptionLabel, studyBookmarkButton, chattingButton, moreButton].forEach{contentView.addSubview($0)}
        
        chattingButton.addTarget(self, action: #selector(didTappdChattingButton), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(didTappdMoreButton), for: .touchUpInside)
    }
    
    public func configureUI(with model: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "bookmark", withConfiguration: config)
        studyBookmarkButton.setImage(image, for: .normal)
        chattingButton.setTitle("담당자와 채팅하기", for: .normal)
        chattingButton.backgroundColor = .systemBlue
        chattingButton.layer.borderWidth = 1
        chattingButton.layer.borderColor = UIColor.systemBlue.cgColor
        moreButton.setTitle("더보기 >", for: .normal)
        moreButton.backgroundColor = .white
        moreButton.layer.borderWidth = 1
        // MOCK DATA
        studyTitleLabel.text = "여성 아티스트 육성 NFT"
        studyDescriptionLabel.text = "SPACE OF WOMEN은 .NET 시장에서 여성 크리에이터들을 늘리기 위한 움직임...ㅇㄹㄴㅇㄹㅁㄴㄹㄴㅁㄹㄴㅁㄹㄴㅁㄹㄴㅁㄹㅁㄴㄹ"
    }
}
