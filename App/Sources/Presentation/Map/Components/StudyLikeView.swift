//
//  StudyLikeView.swift
//  App
//
//  Created by 이건준 on 2022/11/01.
//

import UIKit
import SnapKit
import Then

protocol StudyLikeViewDelegate: AnyObject {
    func didTappedLiketButton()
}

class StudyLikeView: UIView {
    
    weak var delegate: StudyLikeViewDelegate?
    
//    public var isSelected: Bool = false {
//        return self.toggle()
//    }
    
    private let likeCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .lightGray
        $0.text = "12"
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        $0.tintColor = .lightGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        _ = [likeCountLabel, likeButton].map{ addSubview($0) }
        
        likeButton.addTarget(self, action: #selector(didTappedLikeButton), for: .touchUpInside)
        likeCountLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
    }
    
    @objc private func didTappedLikeButton() {
        delegate?.didTappedLiketButton()
    }
}
