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
import Then
import COCommonUI
import CODomain

protocol ProfileViewDelegate: AnyObject {
  func didTapEditProfileButton()
}

public final class ProfileView: UIView {
  
  lazy var profileImageView = ProfileImageView(imageSize: imageSize)
  
  var userNameLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .medium(size: 20)  }
  
  var userPositionLabel = UILabel().then {
    $0.textColor = .hexC6C6C6
    $0.font = .regular(size: 14)
  }
  
  lazy var editButton = UIButton(type: .custom).then {
    if direction != .row {
      $0.setImage(UIImage(systemName: "pencil.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
      $0.contentHorizontalAlignment = .fill
      $0.contentVerticalAlignment = .fill
    } else {
      $0.backgroundColor = .black
      $0.setTitle("프로필 편집", for: .normal)
      $0.setTitleColor(.white, for: .normal)
      $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
      $0.layer.cornerRadius = 8
      $0.layer.masksToBounds = true
    }

    $0.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
  }
  
  private let flexContainer = UIView()
  
  weak var delegate: ProfileViewDelegate?
  
  private let imageSize: ProfileImageSize
  private let direction: Flex.Direction
  
  public init(
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
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin.layout()
    flexContainer.flex.layout()
  }
  
  public func update(
    url: URL? = nil,
    userName: String = "",
    roles: [Role] = []
  ) {
    if let url = url {
      Task {
        await self.profileImageView.setImage(url: url)
      }
    }
    
    userNameLabel.text = userName
    userPositionLabel.text = roles.map { $0.description }.toStringWithComma
  }
}

private extension ProfileView {
  func configureUI() {
    backgroundColor = .white
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(direction == .column ? .column : .row)
      .padding(direction == .row ? 20 : 0)
      .define { flex in
        
        if direction == .column {
          flex.addItem(profileImageView)
            .height(imageSize.value.height)
            .aspectRatio(1)
          
          flex.addItem(editButton)
          
          editButton.flex
            .position(.absolute)
            .top(imageSize.value.height - 30)
            .left(imageSize.value.height - 30)
            .size(30)
            .aspectRatio(1)
        } else {
          flex.addItem(profileImageView)
            .height(imageSize.value.height)
            .aspectRatio(1)
        }
        
        flex.addItem()
          .justifyContent(.spaceAround)
          .alignItems(direction == .row ? .start : .center)
          .padding(10)
          .define { flex in
            flex.addItem(userNameLabel)
            flex.addItem(userPositionLabel)
              .grow(1)
          }
        
        if direction == .row {
          flex.addItem()
            .grow(1)
          
          flex.addItem(editButton)
            .height(30)
            .width(70)
        }
      }
  }
  
  @objc func didTapEditButton() {
    delegate?.didTapEditProfileButton()
  }
}
