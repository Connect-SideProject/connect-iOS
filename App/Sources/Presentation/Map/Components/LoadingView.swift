//
//  LoadingView.swift
//  connect
//
//  Created by 이건준 on 2022/07/29.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    
    private let indicatorView: UIActivityIndicatorView = {
        $0.style = .large
        $0.hidesWhenStopped = true
        $0.startAnimating()
        return $0
    }(UIActivityIndicatorView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureUI() {
        addSubview(indicatorView)
    }
}
