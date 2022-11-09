//
//  DescriptionContainerView.swift
//  COCommonUI
//
//  Created by sean on 2022/09/12.
//

import UIKit

import FlexLayout
import Then

public struct DescriptionItem {
  
  public let title: String
  public let attributedTitle: NSAttributedString
  
  public let castableView: CastableView?
  public let placeholder: String?
  public let noticeText: String?
  
  public init(
    title: String = "",
    attributedTitle: NSAttributedString = .init(string: ""),
    castableView: CastableView? = nil,
    placeholder: String? = nil,
    noticeText: String? = nil
  ) {
    self.title = title
    self.attributedTitle = attributedTitle
    self.castableView = castableView
    self.placeholder = placeholder
    self.noticeText = noticeText
  }
}

public enum DescriptionType {
  // DescriptionLabel, View
  case textField(DescriptionItem)
  case textFieldWithAttributed(DescriptionItem)
  case textView(DescriptionItem)
  case custom(DescriptionItem)
  case customWithAttributed(DescriptionItem)
}

public class DescriptionContainerView: UIView {
  
  private let descriptionLabel = UILabel().then {
    $0.font = .regular(size: 16)
    $0.textColor = .black
  }
  
  public let textField = UITextField().then {
    $0.font = .medium(size: 14)
    $0.textColor = .black
    $0.leftViewMode = .always
    $0.layer.borderColor = UIColor.hexC6C6C6.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
    
    let view = UIView()
    view.frame = .init(x: 0, y: 0, width: 8, height: 36)
    $0.leftView = view
  }
  
  public let textView = UITextView().then {
    $0.font = .medium(size: 14)
    $0.textColor = .black
    $0.layer.borderColor = UIColor.hexC6C6C6.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
  }
  
  public private(set) var customView: CastableView?
  public private(set) var customViews: [CastableView]?
  
  private let noticeTextLabel = UILabel().then {
    $0.font = .regular(size: 12)
    $0.textColor = .red
    $0.numberOfLines = 1
  }
  
  public let flexContainer = UIView()
  
  public var type: DescriptionType = .textField(.init())
  
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
    self.type = type
    
    switch type {
    case let .textField(item):
      descriptionLabel.text = item.title
      textField.placeholder = item.placeholder
      noticeTextLabel.text = item.noticeText
    case let .textFieldWithAttributed(item):
      descriptionLabel.attributedText = item.attributedTitle
      textField.placeholder = item.placeholder
    case let .textView(item):
      descriptionLabel.text = item.title
      textView.text = item.placeholder
      noticeTextLabel.text = item.noticeText
    case let .custom(item):
      descriptionLabel.text = item.title
      customView = item.castableView
      noticeTextLabel.text = item.noticeText
    case let .customWithAttributed(item):
      descriptionLabel.attributedText = item.attributedTitle
      customView = item.castableView
      noticeTextLabel.text = item.noticeText
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
          .marginBottom(10)
        
        if let customView = customView {
          
          if let containerView = customView as? CastableContainerView {
            flex.addItem(containerView)
          } else {
            flex.addItem(customView)
              .height(36)
          }
        } else {
          
          if case .textField = type {
            flex.addItem(textField)
              .height(44)
          }
          
          if case .textView = type {
            flex.addItem(textView)
              .height(155)
          }
        }
        
        if noticeTextLabel.text?.isEmpty == false {
          flex.addItem(noticeTextLabel)
            .marginVertical(8)
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
  public private(set) var selectedItems: [[String]] = []
  
  public let flexContainer = UIView()
  
  public private(set) var views: [CastableView] = []
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
  
  public func setSelectedItems(items: [String]) {
    
    views.forEach {
      let roundSelectionButtonView = $0.casting(type: RoundSelectionButtonView.self)
      roundSelectionButtonView.setSelectedItems(items: items)
      
      if roundSelectionButtonView.selectedItems.count > 0 {
        self.selectedItems.append(roundSelectionButtonView.selectedItems)
      }
    }
  }
}

extension CastableContainerView {
  private func configureUI() {
    
    let height = CGFloat(40 * views.count)
    
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
      let selectedItems = views.map { $0.selectedItems }
      self?.selectedItems = selectedItems
      self?.handler(selectedItems.flatMap { $0 })
    }
    
    let _ = views.map { $0.handler = handler }
  }
}
