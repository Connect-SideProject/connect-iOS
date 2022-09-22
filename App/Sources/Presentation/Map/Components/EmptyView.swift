//
//  EmptyView.swift
//  connect
//
//  Created by 이건준 on 2022/08/16.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    
    private let emptyLabel: UILabel = {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.text = "검색결과가 존재하지않습니다"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emptyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureUI() {
//        self.isHidden = true
        addSubview(emptyLabel)
    }
}
