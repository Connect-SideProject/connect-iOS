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

public struct BottomSheetRoleItem {
  public let roles: [String]
  public var items: [RoleAndCountItem] = []
  
  public init(roles: [String], items: [RoleAndCountItem] = []) {
    self.roles = roles
    self.items = items
  }
}

public extension BottomSheetRoleItem {
  mutating func updateItems(_ items: [RoleAndCountItem]) {
    self.items = items
  }
}

public struct RoleAndCountItem: Identifiable {
  public var id: Int
  public var role: String
  public var count: Int
  
  public init(id: Int = 0, role: String = "", count: Int = 0) {
    self.id = id
    self.role = role
    self.count = count
  }
}
