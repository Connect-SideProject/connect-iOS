//
//  StudyCollectionViewCell.swift
//  connect
//
//  Created by 이건준 on 2022/06/28.
//  Copyright © 2022 sideproj. All rights reserved.
//

import SnapKit
import Then
import UIKit

protocol StudyCollectionViewCellDelegate: AnyObject {
    func didTappedChattingButton()
}

class StudyCollectionViewCell: UICollectionViewCell {
    
//    static let identifer = "StudyCollectionViewCell"
    
    weak var delegate: StudyCollectionViewCellDelegate?
    
    private let studyStatusView = StudyStatusView(status: .모집중)

    private let studyLikeView = StudyLikeView()
    
    private let studyTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = .black
        $0.backgroundColor = .white
    }
    
    private let studyDescriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 3
        $0.textColor = .black
        $0.backgroundColor = .white
    }
    
    private let studyRecruitTypeView = StudyRecruitTypeView()
    
    private let chattingButton: UIButton = {
       let button = UIButton()
        button.setTitle("담당자와 채팅하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        button.titleLabel?.textAlignment = .center
//        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
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
        studyStatusView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        studyLikeView.snp.makeConstraints { make in
            make.top.equalTo(studyStatusView.snp.top)
            make.bottom.equalTo(studyStatusView.snp.bottom)
            make.right.equalToSuperview().offset(-20)
        }
        
        studyTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(studyStatusView.snp.left)
            make.top.equalTo(studyStatusView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }

        chattingButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-20)
        }
        
        studyRecruitTypeView.snp.makeConstraints { make in
            make.left.equalTo(chattingButton.snp.left)
            make.right.equalTo(chattingButton.snp.right)
            make.bottom.equalTo(chattingButton.snp.top).offset(-10)
            make.height.equalTo(20)
        }
        
        studyDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(studyTitleLabel.snp.bottom)
            make.left.equalTo(studyTitleLabel.snp.left)
            make.right.equalTo(studyTitleLabel.snp.right)
            make.bottom.equalTo(studyRecruitTypeView.snp.top)
        }

        
//        moreButton.snp.makeConstraints { make in
//            make.centerY.equalTo(chattingButton.snp.centerY)
//            make.left.equalTo(chattingButton.snp.right).offset(5)
//            make.right.equalToSuperview().offset(-5)
//            make.height.equalTo(40)
////            make.width.equalTo(100)
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        studyStatusView.text = nil
        studyTitleLabel.text = nil
        studyDescriptionLabel.text = nil
        chattingButton.setTitle(nil, for: .normal)
        chattingButton.backgroundColor = nil
        chattingButton.layer.borderWidth = 0
//        moreButton.setTitle(nil, for: .normal)
//        moreButton.backgroundColor = nil
//        moreButton.layer.borderWidth = 0
    }
    
    // MARK: -Action
    @objc private func didTappdChattingButton() {
        delegate?.didTappedChattingButton()
    }
    
    // MARK: -Configure
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        [studyStatusView, studyLikeView, studyTitleLabel, studyDescriptionLabel, studyRecruitTypeView,  chattingButton].forEach{contentView.addSubview($0)}
        
        chattingButton.addTarget(self, action: #selector(didTappdChattingButton), for: .touchUpInside)
        studyRecruitTypeView.configureUI(recruitTypes: [RecruitType.developer, RecruitType.planner, RecruitType.designer])
    }
    
    public func configureUI(with model: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        chattingButton.setTitle("담당자와 채팅하기", for: .normal)
        chattingButton.backgroundColor = .green
        // MOCK DATA
        studyStatusView.text = "모집중"
        studyTitleLabel.text = "여성 아티스트 육성 NFT"
        studyDescriptionLabel.text = "SPACE OF WOMEN은 .NET 시장에서 여성 크리에이터들을 늘리기 위한 움직임...ㅇㄹㄴㅇㄹㅁㄴㄹㄴㅁㄹㄴㅁㄹㄴㅁㄹㄴㅁㄹㅁㄴㄹ"
    }
}
