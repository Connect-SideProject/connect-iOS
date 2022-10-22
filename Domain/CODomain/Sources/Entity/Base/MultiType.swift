//
//  MultiType.swift
//  CODomain
//
//  Created by sean on 2022/10/22.
//

import Foundation

/// 동일 Entity에서 상황에 따라 타입이 다른경우 처리.
public enum MultiType: Codable, Equatable {
  case string(String)
  case int(Int)

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let stringValue = try? container.decode(String.self) {
      self = .string(stringValue)
      return
    }
    if let intValue = try? container.decode(Int.self) {
      self = .int(intValue)
      return
    }
    throw DecodingError.typeMismatch(MultiType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MultiType"))
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .string(let value):
      try container.encode(value)
    case .int(let value):
      try container.encode(value)
    }
  }
}

public extension MultiType {
  var intValue: Int {
    if case let .int(value) = self {
      return value
    } else {
      return -1
    }
  }

  var stringValue: String {
    if case let .string(value) = self {
      return value
    } else {
      return ""
    }
  }
}
