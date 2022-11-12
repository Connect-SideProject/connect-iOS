//
//  StudyRecruitTypeLabel.swift
//  App
//
//  Created by 이건준 on 2022/11/02.
//

import UIKit

enum RecruitType {
    case developer
    case planner
    case designer
    
    var recruitName: String {
        switch self {
        case .designer:
            return "디자이너"
        case .developer:
            return "개발자"
        case .planner:
            return "기획자"
        }
    }
}

class StudyRecruitTypeView: UIView {
    
    private let personImageView = UIImageView(image: UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: .gray))).then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let studyRecruitTypeLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        _ = [personImageView, studyRecruitTypeLabel].map{ addSubview($0) }
        personImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        studyRecruitTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(personImageView.snp.right)
            make.top.bottom.right.equalToSuperview()
        }
    }
    
    public func configureUI(recruitTypes: [RecruitType]) {
        let recruitTypesToString = recruitTypes.map{ $0.recruitName }
        let text = recruitTypesToString.reduce("") { $1 + "|" + $0 }
        studyRecruitTypeLabel.text = text
    }
}

