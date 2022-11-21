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
  
  private let selectedView = CalendarSelectedView()
  
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
    
    let selectedPosition = cellState.selectedPosition()
    
    if cellState.dateBelongsTo == .thisMonth {
      switch selectedPosition {
      case .left, .right, .full:
        dateLabel.textColor = .white
      default:
        dateLabel.textColor = .hex141616
      }
    } else {
      switch selectedPosition {
      case .left, .right, .full:
        dateLabel.textColor = .white
      default:
        dateLabel.textColor = .hexC6C6C6
      }
    }
    
    selectedView.update(cellState: cellState)
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
