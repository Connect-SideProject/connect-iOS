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
    var configuration = UIButton.Configuration.plain()
    configuration.baseBackgroundColor = .white
    configuration.imagePlacement = .trailing
    $0.configuration = configuration
    $0.titleLabel?.font = .regular(size: 14)
    $0.contentHorizontalAlignment = .left
    $0.isUserInteractionEnabled = false
    $0.setImage(.init(named: "ic_check"), for: .normal)
    $0.setTitleColor(.hex8E8E8E, for: .normal)
    $0.setTitleColor(.hex141616, for: .selected)
  }
  
  private let separator = UIView().then {
    $0.backgroundColor = .hexEDEDED
  }
  
  private let flexContainer = UIView()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleButton.isSelected = false
    titleButton.imageView?.isHidden = true
  }
  
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
  
  func setup(title: String, isSelected: Bool) {
    titleButton.setTitle(title, for: .normal)
    titleButton.isSelected = isSelected
    titleButton.imageView?.isHidden = !isSelected
  }
}

private extension BottomSheetListCell {
  private func configureUI() {
    
    self.contentView.addSubview(flexContainer)
    
    flexContainer.flex.define { flex in
      flex.addItem(titleButton)
        .grow(1)
      flex.addItem(separator)
        .height(1)
    }
  }
}
