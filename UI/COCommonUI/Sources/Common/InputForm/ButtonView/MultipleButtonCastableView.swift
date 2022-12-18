//
//  MultipleButtonCastableView.swift
//  COCommonUI
//
//  Created by sean on 2022/12/02.
//

import UIKit

import FlexLayout
import PinLayout
import Then

public final class MultipleButtonCastableView: UIView, CastableView {
  
  public var handler: (Int) -> Void = { _ in }
  
  private let flexContainer = UIView()
  
  public private(set) var buttons: [CastableButton]
  
  public init(buttons: [CastableButton]) {
    self.buttons = buttons
    super.init(frame: .zero)
    
    setupButtons()
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin
      .width(of: self)
      .height(of: self)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  @objc
  public func didTapButton(_ sender: UIButton) {
    handler(sender.tag)
  }
}

extension MultipleButtonCastableView {
  private func setupButtons() {
    buttons = buttons.enumerated().map { [weak self] offset, element -> CastableButton in
      element.handler = { [weak self] in
        self?.handler(offset)
      }
      return element
    }
  }
  
  private func configureUI() {
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(.row)
      .justifyContent(.spaceBetween)
      .define { flex in
        buttons.forEach {
          flex.addItem($0)
        }
    }
  }
}
