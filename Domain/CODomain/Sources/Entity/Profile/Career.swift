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
  
  public var description: String {
    switch self {
    case .aspirant:
      return "지망생"
    case .junior:
      return "주니어"
    case .senior:
      return "시니어"
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
      return nil
    }
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer().decode(String.self)
    
    switch container {
    case "ASPIRANT":
      self = .aspirant
    case "JUNIOR":
      self = .junior
    case "SENIOR":
      self = .senior
    default:
      fatalError("")
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
    }
  }
}
