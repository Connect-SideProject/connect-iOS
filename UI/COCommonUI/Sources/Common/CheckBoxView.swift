//
//  CheckBoxView.swift
//  COCommonUI
//
//  Created by sean on 2022/09/12.
//

import UIKit

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
  
  public init(titles: [String]) {
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
    print(sender.tag)
    print(sender.isSelected)
    
    let selectedList = checkBoxViews.map { $0.checkBoxButton.isSelected }.filter { $0 }
    let selectedTag = checkBoxViews.map { $0.checkBoxButton.isSelected ? $0.checkBoxButton.tag : -1 }
      .filter { $0 != -1 }
      .reduce(0, +)
    
    if selectedList.count == 0 {
      sender.isSelected = true
    } else {
      
      if selectedTag == sender.tag {
        return
      }
      
      let _ = checkBoxViews.map { $0.checkBoxButton.isSelected = false }
      sender.isSelected = true
    }
  }
}

extension CheckBoxContainerView {
  private func configureUI() {
    backgroundColor = .white
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(.row)
      .define { flex in
        checkBoxViews.forEach {
          flex.addItem($0)
            .marginLeft(10)
        }
    }
  }
}

public final class CheckBoxView: UIView {

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
    backgroundColor = .white
    
    addSubview(flexContainer)
    
    flexContainer.flex
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
