//
//  CalendarSelectedView.swift
//  COCommonUI
//
//  Created by sean on 2022/11/21.
//

import UIKit
import JTAppleCalendar

public final class CalendarSelectedView: UIView {
  
  enum Size {
    static let circle: CGFloat = 35
  }
  
  private let circleView = UIView().then {
    $0.backgroundColor = .hex05A647
    $0.layer.cornerRadius = Size.circle / 2
  }
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = .hexD4F6E2
  }
  
  private lazy var leftView = UIView().then {
    let backgroundView = UIView().then {
      $0.backgroundColor = .hexD4F6E2
    }
    let circleView = UIView().then {
      $0.backgroundColor = .hex05A647
      $0.layer.cornerRadius = Size.circle / 2
    }
    $0.addSubview(backgroundView)
    $0.addSubview(circleView)
    
    backgroundView.snp.makeConstraints {
      $0.trailing.centerY.equalToSuperview()
      $0.width.height.equalTo(Size.circle)
    }
    
    circleView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(Size.circle)
    }
  }
  
  private lazy var rightView = UIView().then {
    let backgroundView = UIView().then {
      $0.backgroundColor = .hexD4F6E2
    }
    
    let circleView = UIView().then {
      $0.backgroundColor = .hex05A647
      $0.layer.cornerRadius = Size.circle / 2
    }
    
    $0.addSubview(backgroundView)
    $0.addSubview(circleView)
    
    backgroundView.snp.makeConstraints {
      $0.leading.centerY.equalToSuperview()
      $0.width.height.equalTo(Size.circle)
    }
    
    circleView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(Size.circle)
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(cellState: CellState) {
    switch cellState.selectedPosition() {
    case .left:
      circleView.isHidden = true
      leftView.isHidden = false
      rightView.isHidden = true
      backgroundView.isHidden = true
    case .right:
      circleView.isHidden = true
      leftView.isHidden = true
      rightView.isHidden = false
      backgroundView.isHidden = true
    case .middle:
      circleView.isHidden = true
      leftView.isHidden = true
      rightView.isHidden = true
      backgroundView.isHidden = false
    case .full:
      circleView.isHidden = false
      leftView.isHidden = true
      rightView.isHidden = true
      backgroundView.isHidden = true
    default: break
    }
  }
}

private extension CalendarSelectedView {
  func configureUI() {
    addSubview(backgroundView)
    addSubview(leftView)
    addSubview(rightView)
    addSubview(circleView)
    
    backgroundView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.equalTo(Size.circle)
    }
    
    leftView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    rightView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    circleView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(Size.circle)
    }
  }
}
