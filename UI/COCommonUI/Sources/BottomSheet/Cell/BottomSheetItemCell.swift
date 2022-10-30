//
//  BottomSheetItemCell.swift
//  connectTests
//
//  Created by Kim dohyun on 2022/09/01.
//

import UIKit

import FlexLayout
import PinLayout
import Then

final class BottomSheetItemCell: UICollectionViewCell {
  
  private let titleButton: UIButton = UIButton(type: .custom).then {
    $0.setTitleColor(.hex8E8E8E, for: .normal)
    $0.setTitleColor(.hex141616, for: .selected)
    
    $0.titleLabel?.font = .regular(size: 14)
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 5
    
    $0.isUserInteractionEnabled = false
  }
  
  private let flexContainer = UIView()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleButton.titleLabel?.text = ""
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
    
    titleButton.layer.borderColor = isSelected ?  UIColor.hex141616.cgColor : UIColor.hexEDEDED.cgColor
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin.all()
    flexContainer.flex.layout()
  }
}

private extension BottomSheetItemCell {
  private func configureUI() {
    
    self.contentView.addSubview(flexContainer)
    
    flexContainer.flex.define { flex in
      flex.addItem(titleButton)
        .grow(1)
    }
  }
}
