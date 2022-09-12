//
//  CheckBoxView.swift
//  COCommonUI
//
//  Created by sean on 2022/09/12.
//

import UIKit

import FlexLayout
import PinLayout

public typealias CheckBoxItem = (title: String, index: Int)

public enum CheckBoxContainerDirection {
  case horizontal, vertical
}

public final class CheckBoxContainerView: UIView {
  
  public let flexContainer = UIView()
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin
      .width(of: self)
      .height(of: self)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  private var checkBoxViews: [CheckBoxView] = []
  
  public private(set) var checkedItem: CheckBoxItem?
  
  private let direction: CheckBoxContainerDirection
  
  public init(titles: [String], direction: CheckBoxContainerDirection = .horizontal) {
    self.direction = direction
    super.init(frame: .zero)
    
    self.checkBoxViews = titles.enumerated().map { [weak self] offset, element in
      let checkBox = CheckBoxView(title: element)
      checkBox.checkBoxButton.tag = offset
      checkBox.handler = { [weak self] sender in
        self?.didTapCheckBox(sender: sender)
      }
      return checkBox
    }
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func didTapCheckBox(sender: UIButton) {
    let selectedList = checkBoxViews.map { $0.checkBoxButton.isSelected }.filter { $0 }
    let selectedTag = checkBoxViews.map { $0.checkBoxButton.isSelected ? $0.checkBoxButton.tag : -1 }
      .filter { $0 != -1 }
      .reduce(0, +)
    
    if selectedList.count == 0 {
      sender.isSelected = true
      self.checkedItem = (title: sender.currentTitle ?? "", index: sender.tag)
    } else {
      
      if selectedTag == sender.tag {
        return
      }
      
      let _ = checkBoxViews.map { $0.checkBoxButton.isSelected = false }
      sender.isSelected = true
      self.checkedItem = (title: sender.currentTitle ?? "", index: sender.tag)
    }
  }
}

extension CheckBoxContainerView {
  private func configureUI() {
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(direction == .horizontal ? .row : .column)
      .define { flex in
        if direction == .vertical {
          flex.addItem()
            .height(10)
        }
        
        checkBoxViews.forEach {
          flex.addItem($0)
            .marginLeft(10)
        }
    }
  }
}

public final class CheckBoxSingleView: UIView {
  
  public let flexContainer = UIView()
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin
      .width(of: self)
      .height(of: self)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  private let checkBoxView: CheckBoxView
  
  public private(set) var isChecked: Bool = false
  
  public init(title: String) {
    self.checkBoxView = CheckBoxView(title: title)
    super.init(frame: .zero)
        
    configureUI()
    
    checkBoxView.handler = { [weak self] sender in
      self?.didTapCheckBox(sender: sender)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func didTapCheckBox(sender: UIButton) {
    sender.isSelected.toggle()
    
    isChecked = sender.isSelected
  }
}

extension CheckBoxSingleView {
  private func configureUI() {
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(checkBoxView)
          .marginLeft(10)
    }
  }
}

private final class CheckBoxView: UIView {

  fileprivate let checkBoxButton = UIButton(type: .custom).then {
    let nomalImage = UIImage(systemName: "square")
    let selectedImage = UIImage(systemName: "checkmark.square.fill")
    $0.setImage(nomalImage, for: .normal)
    $0.setImage(selectedImage, for: .selected)
    $0.setTitleColor(.black, for: .normal)
    $0.addTarget(self, action: #selector(didTapCheckBox(_:)), for: .touchUpInside)
  }
  
  fileprivate var handler: (UIButton) -> Void = { _ in }
  
  public let flexContainer = UIView()
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin
      .width(of: self)
      .height(of: self)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  private let title: String
  
  public init(title: String) {
    self.title = title
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CheckBoxView {
  private func configureUI() {
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .alignItems(.start)
      .define { flex in
        checkBoxButton.setTitle(title, for: .normal)
        flex.addItem(checkBoxButton)
          .height(30)
    }
  }
  
  @objc private func didTapCheckBox(_ sender: UIButton) {
    handler(sender)
  }
}
