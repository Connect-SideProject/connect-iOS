//
//  CalendarDateCell.swift
//  COCommonUI
//
//  Created by sean on 2022/11/20.
//

import UIKit
import JTAppleCalendar

final class CalendarDateCell: JTACDayCell {
  
  enum State {
    case normal
    case selected
    case notThisMonth
  }
  
  static let reuseIdentifier: String = "CalendarDateCell"
  
  private let selectedView = UIView().then {
    $0.backgroundColor = .hex05A647
  }
  
  private let dateLabel = UILabel().then {
    $0.font = .bold(size: 14)
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(title: String) {
    dateLabel.text = title
  }
  
  func updateTextColor(state: State = .normal) {
    switch state {
    case .normal:
      dateLabel.textColor = .hex141616
    case .selected:
      dateLabel.textColor = .white
    case .notThisMonth:
      dateLabel.textColor = .hexC6C6C6
    }
  }
  
  func updateSelectedView(cellState: CellState) {
    selectedView.isHidden = !cellState.isSelected
    
    if cellState.dateBelongsTo == .thisMonth {
      dateLabel.textColor = cellState.isSelected ? .white : .hex141616
    } else {
      dateLabel.textColor = cellState.isSelected ? .white : .hexC6C6C6
    }
    
    switch cellState.selectedPosition() {
    case .left:
      selectedView.layer.cornerRadius = 20
      selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    case .middle:
      selectedView.layer.cornerRadius = 0
      selectedView.layer.maskedCorners = []
    case .right:
      selectedView.layer.cornerRadius = 20
      selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    case .full:
      selectedView.layer.cornerRadius = 20
      selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    default: break
    }
  }
}

private extension CalendarDateCell {
  func configureUI() {
    contentView.addSubview(selectedView)
    contentView.addSubview(dateLabel)
    
    selectedView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    dateLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
