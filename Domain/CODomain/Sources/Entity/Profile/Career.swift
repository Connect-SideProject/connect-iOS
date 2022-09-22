//
//  Career.swift
//  CODomain
//
//  Created by sean on 2022/09/19.
//

import Foundation

public enum Career: String, Codable, CustomStringConvertible {
  case aspirant = "ASPIRANT"
  case junior = "JUNIOR"
  case senior = "SENIOR"
  case none
  
  public var description: String {
    switch self {
    case .aspirant:
      return "지망생"
    case .junior:
      return "주니어"
    case .senior:
      return "시니어"
    case .none:
      return ""
    }
  }
  
  public init?(rawValue: String) {
    switch rawValue {
    case "지망생":
      self = .aspirant
    case "주니어":
      self = .junior
    case "시니어":
      self = .senior
    default:
      self = .none
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .aspirant:
      try container.encode("ASPIRANT")
    case .junior:
      try container.encode("JUNIOR")
    case .senior:
      try container.encode("SENIOR")
    case .none:
      break
    }
  }
}
