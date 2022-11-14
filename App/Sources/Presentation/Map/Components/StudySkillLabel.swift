//
//  StudySkillLabel.swift
//  App
//
//  Created by 이건준 on 2022/11/12.
//

import UIKit

class StudySkillLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    public func configureUI(with model: [String]) {
        var entireText = model.joined(separator: ", ")
        
        text = entireText
    }
}
