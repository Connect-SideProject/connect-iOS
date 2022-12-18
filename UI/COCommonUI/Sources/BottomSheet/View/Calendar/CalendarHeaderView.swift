//
//  CalendarHeaderView.swift
//  COCommonUI
//
//  Created by sean on 2022/11/20.
//

import UIKit
import JTAppleCalendar

final class CalendarHeaderView: JTACMonthReusableView  {
  
  static let reuseIdentifier: String = "CalendarHeaderView"
  
  private let containerStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 18
  }
  
  private let monthLabel = UILabel().then {
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  private let daysStackView = UIStackView().then {
    $0.distribution = .fillEqually
    $0.axis = .horizontal
  }
  
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
    
    ["일", "월", "화", "수", "목", "금", "토"].forEach {
      let label = UILabel()
      label.text = $0
      label.textColor = .black
      label.font = .regular(size: 12)
      label.textAlignment = .center
      daysStackView.addArrangedSubview(label)
    }
    
    addSubview(containerStackView)
    
    [monthLabel, daysStackView].forEach {
      containerStackView.addArrangedSubview($0)
    }
    
    containerStackView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
}

