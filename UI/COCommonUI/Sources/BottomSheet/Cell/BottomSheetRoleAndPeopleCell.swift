//
//  BottomSheetRoleAndPeopleCell.swift
//  COCommonUI
//
//  Created by sean on 2022/12/03.
//

import Foundation
import UIKit

import FlexLayout
import PinLayout
import Then

final class BottomSheetRoleAndPeopleCell: UICollectionViewCell {
  
  private var roundSelectionButtonView = RoundSelectionButtonView(
    titles: []
  )
  
  private let stepperContainerView = UIView()
  
  private let stepperView = StepperView(
    minimumValue: 1, maximumValue: 9
  )
  
  private lazy var additionalButton = UIButton(
    type: .custom
  ).then {
    $0.setTitle("+ 추가하기", for: .normal)
    $0.setTitleColor(UIColor.hex06C755, for: .normal)
    $0.addTarget(self, action: #selector(didTapAdditionalButton), for: .touchUpInside)
  }
  
  public var valueHandler: (String, Int) -> Void = { _, _ in }
  public var additionalHandler: () -> Void = { }
  
  private var selectedTitle: String?
  private var item: RoleAndCountItem = .init()
  
  private let flexContainer = UIView()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainer.pin.all()
    flexContainer.flex.layout()
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureUI()
    bindEvent()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(titles: [String], item: RoleAndCountItem) {
    self.item = item
    self.roundSelectionButtonView.updateTitles(titles)
    self.stepperView.updateValue(item.count)
    
    additionalButton.isHidden = (item.id == 3)
  }
}

private extension BottomSheetRoleAndPeopleCell {
  func configureUI() {
    
    contentView.addSubview(flexContainer)
    
    flexContainer.flex
      .define { flex in
        flex.addItem(roundSelectionButtonView)
          .minHeight(50)
        flex.addItem(stepperContainerView)
      }
    
    stepperContainerView.flex
      .height(30)
      .direction(.row)
      .define { flex in
        flex.addItem(stepperView)
          .width(100)
        flex.addItem()
          .grow(1)
        flex.addItem(additionalButton)
      }
  }
  func bindEvent() {
    
    roundSelectionButtonView.handler = { [weak self] in
      self?.selectedTitle = $0
    }
    
    stepperView.handler = { [weak self] value in
      if let selectedTitle = self?.selectedTitle {
        self?.valueHandler(selectedTitle, value)
      } else {
        self?.stepperView.updateValue(0)
        CommonAlert.shared
          .setMessage(.message("역할을 선택해주세요."))
          .show()
      }
    }
  }
  
  @objc func didTapAdditionalButton() {
    additionalHandler()
  }
}

