//
//  BottomSheetListCell.swift
//  COCommonUI
//
//  Created by sean on 2022/10/29.
//

import Foundation
import UIKit

import FlexLayout
import PinLayout
import Then

final class BottomSheetListCell: UICollectionViewCell {
  
  private let titleButton: UIButton = UIButton(type: .custom).then {
    $0.titleLabel?.font = .regular(size: 14)

    $0.setTitleColor(.hex8E8E8E, for: .normal)
    $0.setTitleColor(.hex141616, for: .selected)
    $0.setImage(.init(named: "bottom_components_check"), for: .selected)
  }
  
  private let flexContainer = UIView()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin.all()
    flexContainer.flex.layout()
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension BottomSheetListCell {
  private func configureUI() {
    
    self.contentView.addSubview(flexContainer)
    
    flexContainer.flex.define { flex in
      flex.addItem(titleButton)
        .grow(1)
    }
  }
}
