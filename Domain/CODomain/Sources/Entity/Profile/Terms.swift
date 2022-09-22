//
//  Terms.swift
//  CODomain
//
//  Created by sean on 2022/09/19.
//

import Foundation

public enum Terms: String, CustomStringConvertible, Codable {
  case service = "SEVICE"
  case location = "LOCATION"
  case privacy = "PRIVACY"
  case none
  
  public var description: String {
    switch self {
    case .service:
      return "서비스 이용약관"
    case .location:
      return "위치기반 이용약관"
    case .privacy:
      return "개인정보 이용약관"
    case .none:
      return ""
    }
  }
  
  public init?(rawValue: String) {
    switch rawValue {
    case "서비스 이용약관":
      self = .service
    case "위치기반 이용약관":
      self = .location
    case "개인정보 이용약관":
      self = .privacy
    default:
      self = .none
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .service:
      try container.encode("SEVICE")
    case .location:
      try container.encode("LOCATION")
    case .privacy:
      try container.encode("PRIVACY")
    case .none:
      break
    }
  }
}
