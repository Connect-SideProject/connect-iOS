//
//  BottomSheetItem.swift
//  COCommonUI
//
//  Created by sean on 2022/11/27.
//

import Foundation

public struct BottomSheetItem {
  public let value: String
  public var isSelected: Bool = false
  
  public init(value: String) {
    self.value = value
  }
}

public extension BottomSheetItem {
  mutating func update(isSelected: Bool) {
    self.isSelected = isSelected
  }
}

public struct DateRange: CustomStringConvertible {
  public var description: String {
    let startDateString = start?.toFormattedString() ?? ""
    let endDateString = end?.toFormattedString() ?? ""
    return "\(startDateString) ~ \(endDateString)"
  }
  
  public var start: Date?
  public var end: Date?
}
