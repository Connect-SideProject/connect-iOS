//
//  ProfileView.swift
//  connect
//
//  Created by sean on 2022/07/11.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout

enum ProfileDirectionType {
  case horizontal, vertical
}

struct ProfileViewItem {
  
  let url: URL?
  let userName: String
  let jobGroup: JobGroup
  
  internal init(url: URL?, userName: String, jobGroup: JobGroup) {
    self.url = url
    self.userName = userName
    self.jobGroup = jobGroup
  }
}

protocol ProfileViewDelegate: AnyObject {
  func didTapEditProfileButton()
}

final class ProfileView: UIView {
  
  private lazy var profileImageView = ProfileImageView(imageSize: imageSize)
  
  private var userNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    return label
  }()
  
  private var userPositionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    return label
  }()
  
  private lazy var profileEditButton: RoundRutton = {
    let button = RoundRutton()
    button.setTitle("프로필 편집", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    return button
  }()
  
  private let flexContainer = UIView()
  
  weak var delegate: ProfileViewDelegate?

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
    
    flexContainer.pin.width(100%).layout()
    flexContainer.flex.layout()
  }
  
  func update(item: ProfileViewItem) {
    if let url = item.url {
      Task {
        await self.profileImageView.setImage(url: url)
      }
    }
    
    userNameLabel.text = item.userName
    userPositionLabel.text = item.jobGroup.description
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
      
      flex.addItem()
        .grow(1)
        .define { flex in
          flex.addItem(profileEditButton)
            .alignSelf(.end)
            .height(35)
            .width(100)
        }
    }
  }
  
  @objc private func didTapEditProfileButton() {
    delegate?.didTapEditProfileButton()
  }
}
