//
//  AnonymousProfileCollectionViewCell.swift
//  connect
//
//  Created by 이건준 on 2022/08/06.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

class AnonymousProfileCollectionViewCell: UICollectionViewCell {
    
//    static let identifier = "AnonymousProfileCollectionViewCell"
    
    private let skillLabel: UILabel = {
        $0.text = "dsfdsaf"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .black
        $0.textColor = .white
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
        
        skillLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureUI() {
        contentView.addSubview(skillLabel)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    public func configureUI(with model: String) {
        skillLabel.text = model
    }
}
