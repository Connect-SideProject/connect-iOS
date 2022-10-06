//
//  ProfileSubItemStackView.swift
//  connect
//
//  Created by sean on 2022/08/07.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

final class ProfileSubItemStackView: UIStackView {
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = item.subtitle
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.textColor = .black
    return label
  }()
  
  private lazy var subjectLabel: UILabel = {
    let label = UILabel()
    label.text = item.content
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .black
    return label
  }()
  
  private let item: ProfileSubItem
  
  init(item: ProfileSubItem) {
    self.item = item
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProfileSubItemStackView {
  private func configureUI() {
    
    axis = .horizontal
    distribution = .equalSpacing
    
    addArrangedSubview(titleLabel)
    addArrangedSubview(subjectLabel)
  }
}
