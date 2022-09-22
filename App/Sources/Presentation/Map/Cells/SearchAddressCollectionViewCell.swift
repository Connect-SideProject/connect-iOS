//
//  SearchMapCollectionViewCell.swift
//  connect
//
//  Created by 이건준 on 2022/07/28.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

class SearchAddressCollectionViewCell: UICollectionViewCell {
    
//    static let identifier = "SearchAddressCollectionViewCell"
    
    private let addressLabel: UILabel = {
        $0.font = .systemFont(ofSize: 15)
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
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.lessThanOrEqualToSuperview()
        }
    }
    
    private func configureUI() {
        contentView.addSubview(addressLabel)
    }
    
    public func configureUI(with model: KakaoMapAddress?) {
        guard let model = model else { return }
        addressLabel.text = model.addressName
    }
}
