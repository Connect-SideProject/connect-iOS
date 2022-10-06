//
//  DescriptionContainerView.swift
//  COCommonUI
//
//  Created by sean on 2022/09/12.
//

import UIKit

import FlexLayout
import Then

public enum DescriptionType {
  // DescriptionLabel, View
  case textField(String, String?)
  case custom(String, CastableView)
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
  
  public private(set) var customView: CastableView?
  public private(set) var customViews: [CastableView]?
  
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
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    endEditing(true)
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
          
          if let containerView = customView as? CastableContainerView {
            flex.addItem(containerView)
          } else {
            flex.addItem(customView)
              .height(36)
          }
        } else {
          flex.addItem(textField)
            .height(36)
        }
      }
  }
}

public final class CastableContainerView: UIView, CastableView {
  
  enum Height {
    static let `default`: CGFloat = 30
  }
  
  enum Margin {
    static let `default`: CGFloat = 6
  }
  
  public var handler: ([String]) -> Void = { _ in }
  public var selectedItems: [String] = []
  
  public let flexContainer = UIView()
  
  private let views: [CastableView]
  private let direction: Flex.Direction
  
  public init(views: [CastableView], direction: Flex.Direction = .column) {
    self.views = views
    self.direction = direction
    super.init(frame: .zero)
    
    configureUI()
    bindEvent()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    self.pin
      .width(of: self)
      .height(of: self)
  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    endEditing(true)
  }
}

extension CastableContainerView {
  private func configureUI() {
    
    let height = CGFloat(36 * views.count)
    
    backgroundColor = .clear
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(direction)
      .define { flex in
        views.forEach {
          if direction == .column || direction == .columnReverse {
            flex.addItem($0)
              .minHeight(height)
              .marginBottom(Margin.default)
          } else {
            flex.addItem($0)
              .height(Height.default)
              .marginRight(Margin.default)
          }
        }
      }
  }
  
  private func bindEvent() {
    let views = views.map { $0.casting(type: RoundSelectionButtonView.self) }
    
    let handler: (String) -> Void = { [weak self] _ in
      let selectedItems = views.map { $0.selectedItems }.flatMap { $0 }
      self?.selectedItems = selectedItems
      self?.handler(selectedItems)
    }
    
    let _ = views.map { $0.handler = handler }
  }
}
