//
//  Base.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

public enum ResponseStatus: Decodable {
  case success, failed
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer().decode(String.self)
    
    switch container {
    case "SUCCESS":
      self = .success
    default:
      self = .failed
    }
  }
}

/// 공통 응답 Entity
public struct Base<T>: Decodable where T: Decodable {
  
  /// 응답 상태 메시지.
  public let status: ResponseStatus
  /// 응답 메시지 내용.
  public let message: String
  /// 응답 결과.
  public let data: T?
  /// 에러 코드 (디버깅).
  public let errorCode: String?

  public init(from decoder: Decoder) throws {
    let container =  try decoder.container(keyedBy: CodingKeys.self)

    self.status =    try container.decodeIfPresent(ResponseStatus.self, forKey: .status) ?? .failed
    self.message =   try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    self.data =      try container.decodeIfPresent(T.self, forKey: .data)
    self.errorCode = try container.decodeIfPresent(String.self, forKey: .errorCode)
  }

  enum CodingKeys: String, CodingKey {
    case status = "result"
    case message
    case data
    case errorCode = "error_code"
  }
}

public extension Base {
  init(status: ResponseStatus, message: String, data: T?) {
    self.status = status
    self.message = message
    self.data = data
    self.errorCode = nil
  }
}

public struct EmptyResponse: Decodable {}
