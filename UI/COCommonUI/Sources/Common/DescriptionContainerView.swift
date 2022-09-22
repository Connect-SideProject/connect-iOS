//
//  DescriptionContainerView.swift
//  COCommonUI
//
//  Created by sean on 2022/09/12.
//

import UIKit

import Then

public enum DescriptionType {
  // DescriptionLabel, View
  case textField(String, String?)
  case custom(String, UIView)
}

public class DescriptionContainerView: UIView {

  private let descriptionLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = .black
  }
  
  public let textField = UITextField().then {
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = .black
    $0.leftViewMode = .always
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
    
    let view = UIView()
    view.frame = .init(x: 0, y: 0, width: 8, height: 36)
    $0.leftView = view
  }
  
  public private(set) var customView: UIView?
  
  public let flexContainer = UIView()
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin
      .width(of: self)
      .height(of: self)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  public init(type: DescriptionType) {
    super.init(frame: .zero)
    
    switch type {
    case let .textField(text, placeholder):
      descriptionLabel.text = text
      textField.placeholder = placeholder
    case let .custom(text, view):
      descriptionLabel.text = text
      customView = view
    }
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DescriptionContainerView {
  private func configureUI() {
    backgroundColor = .white
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .define { flex in
        flex.addItem(descriptionLabel)
          .marginBottom(4)
        if let customView = customView {
          flex.addItem(customView)
            .height(36)
        } else {
          flex.addItem(textField)
            .height(36)
        }
    }
  }
}
