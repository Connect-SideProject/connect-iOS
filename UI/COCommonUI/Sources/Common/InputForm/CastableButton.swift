//
//  CastableButton.swift
//  COCommonUI
//
//  Created by sean on 2022/10/30.
//

import UIKit

import FlexLayout
import PinLayout

public enum CastableButtonType {
  case downwordArrow(String)
}

public final class CastableButton: UIButton, CastableView {
  
  public var handler: () -> Void = { }
  
  public init(type: CastableButtonType) {
    super.init(frame: .zero)
    
    configureUI(type: type)
    bindEvent()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
}

private extension CastableButton {
  func configureUI(type: CastableButtonType) {
    
    switch type {
    case let .downwordArrow(title):
      setTitle(title, for: .normal)
      setImage(UIImage(named: "ic_downward_arrow"), for: .normal)
      
      contentHorizontalAlignment = .left
      
      semanticContentAttribute = UIApplication.shared
          .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
    }
    
    var configuration = UIButton.Configuration.bordered()
    configuration.imagePadding = 8
    configuration.baseBackgroundColor = .clear
    self.configuration = configuration
    
    setTitleColor(.hex3A3A3A, for: .normal)
    titleLabel?.font = .regular(size: 16)
  }
  
  func bindEvent() {
    addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  @objc func didTapButton() {
    handler()
  }
}
