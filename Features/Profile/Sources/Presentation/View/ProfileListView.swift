//
//  ProfileListView.swift
//  connect
//
//  Created by sean on 2022/08/07.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import Then

final class ProfileListView: UIView {
  
  private lazy var titleLabel = UILabel().then {
    $0.text = item.title
    $0.font = .regular(size: 16)
    $0.textColor = .black
  }
  
  private lazy var subjectLabel = UILabel().then {
    $0.text = item.content
    $0.font = .regular(size: 14)
    $0.textColor = .black
    $0.textAlignment = .right
  }
  
  private let flexContainer = UIView()
  
  private let item: ProfileViewItem
  
  init(item: ProfileViewItem) {
    self.item = item
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin.layout()
    flexContainer.flex.layout()
  }
  
  public func update(item: ProfileViewItem) {
    titleLabel.text = item.title
    subjectLabel.text = item.content
  }
}

extension ProfileListView {
  private func configureUI() {
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(titleLabel)
          .maxWidth(100)
        flex.addItem(subjectLabel)
          .grow(1)
          .markDirty()
    }
  }
}
