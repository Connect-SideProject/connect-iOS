//
//  ProfileView.swift
//  connect
//
//  Created by sean on 2022/07/11.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

import CODomain
import COCommonUI
import FlexLayout
import PinLayout

enum ProfileDirectionType {
  case horizontal, vertical
}

class ProfileView: UIView {
  
  lazy var profileImageView = ProfileImageView(imageSize: imageSize)
  
  var userNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    return label
  }()
  
  var userPositionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    return label
  }()
  
  private let flexContainer = UIView()

  let imageSize: ProfileImageSize
  let direction: Flex.Direction
  
  init(
    imageSize: ProfileImageSize = .medium,
    direction: Flex.Direction = .row
  ) {
    self.imageSize = imageSize
    self.direction = direction
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin.layout()
    flexContainer.flex.layout()
  }
  
  func update(
    url: URL? = nil,
    userName: String = "",
    roles: [Role] = [.none]
  ) {
    if let url = url {
      Task {
        await self.profileImageView.setImage(url: url)
      }
    }
    
    userNameLabel.text = userName
    userPositionLabel.text = roles.map { $0.description }.reduce("", { acc, value in
      acc + ", \(value)"
    })
  }
}

extension ProfileView {
  private func configureUI() {
    backgroundColor = .white
    
    addSubview(flexContainer)
    
    flexContainer.flex.direction(direction).padding(20).define { flex in
      flex.addItem(profileImageView)
        .height(imageSize.value.height)
        .aspectRatio(1)
      
      flex.addItem().justifyContent(.spaceAround)
        .padding(10)
        .define { flex in
          flex.addItem(userNameLabel)
          flex.addItem(userPositionLabel)
        }
    }
  }
}
