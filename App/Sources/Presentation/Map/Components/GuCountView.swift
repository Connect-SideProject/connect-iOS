//
//  GuCountView.swift
//  connectUITests
//
//  Created by 이건준 on 2022/07/22.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

protocol GuCountViewDelegate: AnyObject {
    func tappedGuCountView()
}

struct GuCountViewModel {
    let title: String
    let count: Int
}

class GuCountView: UIButton {

//    weak var delegate: GuCountViewDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc private func tappedGuCountView() {
//        delegate?.tappedGuCountView()
//    }
    
    private func configureUI() {
        isUserInteractionEnabled = true
        layer.cornerRadius = 50
        backgroundColor = .systemGray
        setTitleColor(.white, for: .normal)
//        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 2
//        textColor = .white
//        textAlignment = .center
        clipsToBounds = true
//        numberOfLines = 2
    }
    
    public func configureUI(with model: GuCountViewModel) {
        print("model = \(model)")
        setTitle("\(model.title)\n\(model.count)명", for: .normal)
    }
}
