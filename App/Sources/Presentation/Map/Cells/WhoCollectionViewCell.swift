//
//  StudyCollectionViewCell.swift
//  connect
//
//  Created by 이건준 on 2022/07/26.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit
import Then

protocol WhoCollectionViewCellDelegate: AnyObject {
    func didTappedChattingButton()
}

class WhoCollectionViewCell: UICollectionViewCell {
    
//    static let identifier = "WhoCollectionViewCell"
    
    weak var delegate: WhoCollectionViewCellDelegate?
    
    private let nameLabel = UnderlineLabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let studySkillLabel = StudySkillLabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let chattingButton = UIButton().then {
        $0.setTitle("담당자와 채팅하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        $0.titleLabel?.textAlignment = .center
//        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
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
        chattingButton.setTitle(nil, for: .normal)
        chattingButton.backgroundColor = nil
        chattingButton.layer.borderWidth = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        
        chattingButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-20)
        }
        
        studySkillLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.right.equalTo(nameLabel)
            make.bottom.equalTo(chattingButton.snp.top)
        }
        
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        [nameLabel, chattingButton, studySkillLabel].forEach{contentView.addSubview($0)}
        
//        profileButton.addTarget(self, action: #selector(didTappedProfileButton), for: .touchUpInside)
    }
    
    public func configureUI(with model: String) {
        // MOCK
        nameLabel.text = "익명의 커넥터"
        chattingButton.setTitle("채팅하기", for: .normal)
        chattingButton.backgroundColor = .green
        studySkillLabel.configureUI(with: ["자바", "스위프트", "코틀린", "C언어", "C#", "C++", "파이썬"])
    }
    
    @objc private func didTappedChattingButton() {
        delegate?.didTappedChattingButton()
    }
}
