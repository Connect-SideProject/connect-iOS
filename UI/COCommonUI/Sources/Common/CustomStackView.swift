//
//  CustomStackView.swift
//  COCommonUI
//
//  Created by Taeyoung Son on 2022/12/10.
//

import UIKit

class HStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.axis = .horizontal
    }
}

class VStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.axis = .vertical
    }
}

