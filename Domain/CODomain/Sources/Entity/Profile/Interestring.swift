//
//  Interestring.swift
//  CODomain
//
//  Created by sean on 2022/09/19.
//

import Foundation

public enum Interestring: String, Codable, CustomStringConvertible {
  case finance = "FINANCE"
  case fashion = "FASHION"
  case health = "HEALTH"
  case entertainment = "ENTERTAINMENT"
  
  public var description: String {
    switch self {
    case .finance:
      return "금융"
    case .fashion:
      return "패션"
    case .health:
      return "헬스케어"
    case .entertainment:
      return "엔터테인먼트"
    }
  }
  
  public init?(rawValue: String) {
    switch rawValue {
    case "금융":
      self = .finance
    case "패션":
      self = .fashion
    case "헬스케어":
      self = .health
    case "엔터테인먼트":
      self = .entertainment
    default:
      return nil
    }
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer().decode(String.self)
    
    switch container {
    case "FINANCE":
      self = .finance
    case "FASHION":
      self = .fashion
    case "HEALTH":
      self = .health
    case "ENTERTAINMENT":
      self = .entertainment
    default:
      fatalError("")
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .finance:
      try container.encode("FINANCE")
    case .fashion:
      try container.encode("FASHION")
    case .health:
      try container.encode("HEALTH")
    case .entertainment:
      try container.encode("ENTERTAINMENT")
    }
  }
}
