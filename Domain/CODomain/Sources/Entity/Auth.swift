//
//  Auth.swift
//  CODomain
//
//  Created by sean on 2022/09/04.
//

import Foundation

public enum AuthType: Int, CustomStringConvertible, CaseIterable, Codable {
  case kakao = 0, naver, apple
  
  public var description: String {
    switch self {
    case .kakao:
      return "KAKAO"
    case .naver:
      return "NAVER"
    case .apple:
      return "APPLE"
    }
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer().decode(String.self)
    
    switch container {
    case "KAKAO":
      self = .kakao
    case "NAVER":
      self = .naver
    case "APPLE":
      self = .apple
    default:
      fatalError("")
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .kakao:
      try container.encode("KAKAO")
    case .naver:
      try container.encode("NAVER")
    case .apple:
      try container.encode("APPLE")
    }
  }
}

extension AuthType {
  static func convertType(value: String) -> Self? {
      switch value {
      case AuthType.kakao.description:
        return .kakao
      case AuthType.naver.description:
        return .naver
      case AuthType.apple.description:
        return .apple
      default:
        return nil
      }
  }
}
