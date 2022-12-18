//
//  StepperView.swift
//  COCommonUI
//
//  Created by sean on 2022/12/03.
//

import UIKit

import FlexLayout
import PinLayout
import Then

public final class StepperView: UIView {
  
  enum Width {
    static let button: CGFloat = 30
    static let countLabel: CGFloat = 25
  }

  private lazy var prevButton = UIButton(type: .custom).then {
    $0.setTitle("-", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .hex06C755
    $0.layer.cornerRadius = Width.button / 2
    $0.layer.masksToBounds = true
    $0.tag = 0
    $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  private lazy var nextButton = UIButton(type: .custom).then {
    $0.setTitle("+", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .hex06C755
    $0.layer.cornerRadius = Width.button / 2
    $0.layer.masksToBounds = true
    $0.tag = 1
    $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  private lazy var countLabel = UILabel().then {
    $0.text = "\(value)"
    $0.font = .bold(size: 18)
    $0.textColor = .hex3A3A3A
    $0.textAlignment = .center
  }
  
  private let flexContainer = UIView()
  
  public private(set) var value: Int
  
  public var handler: (Int) -> Void = { _ in }

  private let minimumValue: Int
  private let maximumValue: Int
  
  public init(
    minimumValue: Int = 0,
    maximumValue: Int = 10,
    currentValue: Int = 0
  ) {
    self.minimumValue = minimumValue
    self.maximumValue = maximumValue
    self.value = currentValue
    super.init(frame: .zero)
    
    configureUI()
    bindEvent()
  }
  
  public func updateValue(_ value: Int) {
    self.value = value
    self.countLabel.text = "\(value)"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension StepperView {
  func configureUI() {
    addSubview(flexContainer)
    
    flexContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(prevButton)
          .minWidth(Width.button)
        flex.addItem(countLabel)
          .grow(1)
        flex.addItem(nextButton)
          .minWidth(Width.button)
    }
  }
  
  @objc func didTapButton(_ sender: UIButton) {
    let didTapPrev = (sender.tag == 0)
    
    if didTapPrev, value < minimumValue {
      return
    }
    
    if !didTapPrev, value >= maximumValue {
      return
    }
    
    if didTapPrev {
      value -= 1
    } else {
      value += 1
    }
    
    countLabel.text = "\(value)"
    handler(value)
  }
  
  func bindEvent() {
    
  }
}
