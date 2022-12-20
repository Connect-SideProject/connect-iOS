//
//  CalendarHeaderView.swift
//  COCommonUI
//
//  Created by sean on 2022/11/20.
//

import UIKit
import JTAppleCalendar

enum CalendarHeaderDirection {
  case prev, next
}

protocol CalendarHeaderViewDelegate: AnyObject {
  func didTapDirectionButton(direction: CalendarHeaderDirection)
}

final class CalendarHeaderView: JTACMonthReusableView  {
  
  static let reuseIdentifier: String = "CalendarHeaderView"
  
  private let containerStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 18
  }
  
  private let monthContainerView = UIView()
  
  private let monthLabel = UILabel().then {
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  private lazy var prevButton = UIButton().then {
    $0.setImage(.init(named: "ic_prev"), for: .normal)
    $0.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
  }
  
  private lazy var nextButton = UIButton().then {
    $0.setImage(.init(named: "ic_next"), for: .normal)
    $0.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
  }
  
  private let monthStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 16
  }
  
  private let daysStackView = UIStackView().then {
    $0.distribution = .fillEqually
    $0.axis = .horizontal
  }
  
  weak var delegate: CalendarHeaderViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(title: String) {
    monthLabel.text = title
  }
}

private extension CalendarHeaderView {
  func configureUI() {
    
    monthStackView.addArrangedSubview(prevButton)
    monthStackView.addArrangedSubview(monthLabel)
    monthStackView.addArrangedSubview(nextButton)
        
    monthContainerView.addSubview(monthStackView)
    containerStackView.addSubview(monthContainerView)
    
    prevButton.snp.makeConstraints {
      $0.width.equalTo(16)
    }
    
    nextButton.snp.makeConstraints {
      $0.width.equalTo(16)
    }
    
    monthStackView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    monthContainerView.snp.makeConstraints {
      $0.width.equalTo(152)
    }
    
    ["일", "월", "화", "수", "목", "금", "토"].forEach {
      let label = UILabel()
      label.text = $0
      label.textColor = .black
      label.font = .regular(size: 12)
      label.textAlignment = .center
      daysStackView.addArrangedSubview(label)
    }
    
    [monthContainerView, daysStackView].forEach {
      containerStackView.addArrangedSubview($0)
    }
    
    addSubview(containerStackView)
    
    containerStackView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  @objc func didTapPrevButton() {
    delegate?.didTapDirectionButton(direction: .prev)
  }
  
  @objc func didTapNextButton() {
    delegate?.didTapDirectionButton(direction: .next)
  }
}

