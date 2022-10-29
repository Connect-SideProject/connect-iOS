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

/// CheckBoxContainer의 CheckBoxView가 나열되는 방향
public enum CheckBoxContainerDirection {
  case horizontal, vertical
}

/// CheckBoxContainer의 버튼 이벤트 처리 종류
/// radio: 컨테이너 버튼체크 중복되지 않도록 동작 (라디오버튼)
/// default: 컨테이너 버튼체크 중복가능 (기본)
public enum CheckBoxContainerEventType {
  case radio, `default`
}

/// 두개 이상의 CheckBox가 포함된 Container.
public final class CheckBoxContainerView: UIView, CastableView {
  
  public private(set) var checkedItems: [CheckBoxItem]?
  
  public var handler: ([CheckBoxItem]) -> Void = { _ in }
  
  private var checkBoxViews: [CheckBoxView] = []
  
  private let flexContainer = UIView()
  
  private let direction: CheckBoxContainerDirection
  private let eventType: CheckBoxContainerEventType
  
  public init(titles: [String], direction: CheckBoxContainerDirection = .horizontal, eventType: CheckBoxContainerEventType = .default) {
    self.direction = direction
    self.eventType = eventType
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
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin
      .width(of: self)
      .height(of: self)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  public func setSelectedItems(items: [String]) {
      let items: [CheckBoxItem] = checkBoxViews.map {
      if items.contains($0.title) {
        $0.checkBoxButton.isSelected = true
        return CheckBoxItem(title: $0.title, index: $0.checkBoxButton.tag)
      }
      
      return CheckBoxItem(title: "", index: -1)
    }.filter { $0.index != -1 }
    
    checkedItems = items
  }
  
  /// 모든 CheckBox 체크 설정 및 해제.
  public func checkedAll() {
    let selectedList = checkBoxViews.map { $0.checkBoxButton.isSelected }.filter { $0 }
    
    let _ = checkBoxViews.map {
      if selectedList.count == checkBoxViews.count {
        $0.checkBoxButton.isSelected = false
      } else {
        $0.checkBoxButton.isSelected = true
      }
    }
    
    updateCheckedItems()
  }
}

private extension CheckBoxContainerView {
  func configureUI() {
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(direction == .horizontal ? .row : .column)
      .marginHorizontal(10)
      .define { flex in
        if direction == .vertical {
          flex.addItem()
            .height(10)
        }
        
        checkBoxViews.forEach {
          flex.addItem($0)
            .marginRight(30)
        }
    }
  }
  
  func didTapCheckBox(sender: UIButton) {
    switch eventType {
    case .radio:
      methodRadio(sender: sender)
    case .default:
      methodDefault(sender: sender)
    }
    
    handler(checkedItems ?? [])
  }
  
  func methodRadio(sender: UIButton) {
    let selectedList = checkBoxViews.map { $0.checkBoxButton.isSelected }.filter { $0 }
    let selectedTag = checkBoxViews.map { $0.checkBoxButton.isSelected ? $0.checkBoxButton.tag : -1 }
      .filter { $0 != -1 }
      .reduce(0, +)
    
    if selectedList.count == 0 {
      sender.isSelected = true
      self.checkedItems = [(title: sender.currentTitle ?? "", index: sender.tag)]
    } else {
      
      if selectedTag == sender.tag {
        return
      }
      
      let _ = checkBoxViews.map { $0.checkBoxButton.isSelected = false }
      sender.isSelected = true
      self.checkedItems = [(title: sender.currentTitle ?? "", index: sender.tag)]
    }
  }
  
  func methodDefault(sender: UIButton) {
    sender.isSelected.toggle()
    
    updateCheckedItems()
  }
  
  func updateCheckedItems() {
    self.checkedItems = checkBoxViews
      .map {
        if $0.checkBoxButton.isSelected {
          return CheckBoxItem(title: $0.checkBoxButton.currentTitle ?? "", index: $0.checkBoxButton.tag)
        } else {
          return CheckBoxItem(title: "", index: -1)
        }
      }
      .filter { $0.index != -1 }
  }
}

/// 단일 CheckBox.
public final class CheckBoxSingleView: UIView {
  
  private lazy var checkBoxView = CheckBoxView(title: title)
  
  /// 단일 CheckBox의 체크 여부.
  public private(set) var isChecked: Bool = false
  
  /// 단일 CheckBox의 체크 이벤트 핸들러.
  public var handler: (Bool) -> Void = { _ in }
  
  public let flexContainer = UIView()
  
  private let title: String
  
  public init(title: String) {
    self.title = title
    super.init(frame: .zero)
    
    configureUI()
    
    bindEvent()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setChecked(_ isChecked: Bool) {
    self.isChecked = isChecked
    
    checkBoxView.checkBoxButton.isSelected = isChecked
  }
}

private extension CheckBoxSingleView {
  func configureUI() {
    
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(checkBoxView)
          .marginLeft(10)
    }
  }
  
  func bindEvent() {
    checkBoxView.handler = { [weak self] sender in
      guard let self = self else { return }
      sender.isSelected.toggle()
      self.isChecked = sender.isSelected
      self.handler(sender.isSelected)
    }
  }
  
  func didTapCheckBox(_ sender: UIButton) {
    sender.isSelected.toggle()
    
    isChecked = sender.isSelected
  }
}

/// [v] Title 형태의 기본 CheckBox.
fileprivate final class CheckBoxView: UIView {

  fileprivate lazy var checkBoxButton = UIButton(type: .custom).then {
    $0.titleLabel?.font = .subTitle01
    
    var configuration = UIButton.Configuration.bordered()
    configuration.imagePadding = 8
    configuration.baseBackgroundColor = .clear
    configuration.contentInsets = .init(top: 0, leading: -8, bottom: 0, trailing: 0)
    $0.configuration = configuration
    
    let nomalImage = UIImage(named: "ic_radio_inactive")
    let selectedImage = UIImage(named: "ic_radio_active")
    $0.setImage(nomalImage, for: .normal)
    $0.setImage(selectedImage, for: .selected)
    $0.setTitleColor(UIColor.gray06, for: .normal)
    $0.setTitleColor(UIColor.gray06, for: .selected)
    $0.addTarget(self, action: #selector(didTapCheckBox(_:)), for: .touchUpInside)
  }
  
  fileprivate var handler: (UIButton) -> Void = { _ in }
  
  private let flexContainer = UIView()
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin
      .width(of: self)
      .height(of: self)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  public private(set) var title: String
  
  public init(title: String) {
    self.title = title
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc public func didTapCheckBox(_ sender: UIButton) {
    handler(sender)
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
}
