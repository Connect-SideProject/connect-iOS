//
//  MenuButtonContainerView.swift
//  connect
//
//  Created by sean on 2022/08/07.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout

fileprivate struct MenuButtonItem {
  let title: String
  let titleColor: UIColor
  let image: UIImage?
  
  init(title: String, titleColor: UIColor = .black, image: UIImage?) {
    self.title = title
    self.titleColor = titleColor
    self.image = image
  }
}

public enum MenuButtonType {
  
  case appliedGroup, wroteGroup, bookmarkedGroup
  
  fileprivate var item: MenuButtonItem {
      switch self {
      case .appliedGroup:
        return .init(
          title: "내가 지원한 모임",
          image: UIImage(systemName: "folder.fill")
        )
      case .wroteGroup:
        return .init(
          title: "내가 작성한 모임",
          image: UIImage(systemName: "folder.fill")
        )
      case .bookmarkedGroup:
        return .init(
          title: "내가 찜한 모임",
          image: UIImage(systemName: "folder.fill")
        )
      }
  }
}

public final class MenuButtonContainerView: UIView {
  
  private let flexContainer = UIView()
  
  private var buttons: [RoundRutton] = []
  private var items: [MenuButtonItem] = []
  private let types: [MenuButtonType]
  
  public var handler: (Int) -> Void = { _ in }
  
  public init(types: [MenuButtonType]) {
    self.types = types
    super.init(frame: .zero)
    
    setupItems()
    setupButtons()
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin
      .width(100%)
      .height(100%)
      .horizontally()
      .layout()
    flexContainer.flex.layout()
  }
  
  @objc func didTapButton(_ sender: UIButton) {
    handler(sender.tag)
  }
}

extension MenuButtonContainerView {
  private func setupItems() {
    items =  types.map { $0.item }
  }
  
  private func setupButtons() {
    buttons = items.enumerated().map { offset, element -> RoundRutton in
      let button = RoundRutton()
      button.setTitle(element.title, for: .normal)
      button.setTitleColor(element.titleColor, for: .normal)
      button.setImage(
        element.image?
          .withTintColor(.lightGray)
          .withRenderingMode(.alwaysOriginal),
        for: .normal
      )
      button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
      button.tag = offset
      button.addTarget(
        self,
        action: #selector(didTapButton),
        for: .touchUpInside
      )
      return button
    }
  }
  
  private func configureUI() {
    backgroundColor = .white
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .justifyContent(.spaceBetween)
      .direction(.row)
      .define { flex in
        self.buttons.forEach {
          flex.addItem($0)
            .shrink(1)
        }
      }
  }
}
