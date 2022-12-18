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

public struct DateRange {
  public var start: Date?
  public var end: Date?
  
  public init(start: Date? = nil, end: Date? = nil) {
    self.start = start
    self.end = end
  }
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

public struct RoleAndCountItem: Codable, Identifiable {
  public var id: Int = 0
  public var role: String
  public var count: Int
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.role = try container.decodeIfPresent(String.self, forKey: .role) ?? ""
    self.count = try container.decodeIfPresent(Int.self, forKey: .count) ?? -1
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(role, forKey: .role)
    try container.encode(count, forKey: .count)
  }
  
  enum CodingKeys: String, CodingKey {
    case role
    case count
  }
}

public extension RoleAndCountItem {
  init(id: Int = 0, role: String = "", count: Int = 0) {
    self.id = id
    self.role = role
    self.count = count
  }
}
