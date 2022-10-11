//
//  GrayNormalLabel.swift
//  connect
//
//  Created by 이건준 on 2022/08/09.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

class GrayNormalLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.font = .systemFont(ofSize: 15)
        self.textColor = .systemGray
    }
}
