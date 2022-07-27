//
//  Base.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

/// 공통 응답 Entity
struct Base<T>: Decodable where T: Decodable {

  /// 응답 상태 코드.
  let statusCode: Int
  /// 에러 메시지 내용.
  let message: String
  /// 응답 결과.
  let data: T?

  init(from decoder: Decoder) throws {
    let container =   try decoder.container(keyedBy: CodingKeys.self)

    self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? -1
    self.message =    try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    self.data =       try container.decodeIfPresent(T.self, forKey: .data)
  }

  enum CodingKeys: String, CodingKey {
    case statusCode = "code"
    case message = "msg"
    case data
  }
}

struct EmptyResponse: Decodable {}
