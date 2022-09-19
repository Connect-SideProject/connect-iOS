//
//  Parameterable.swift
//  CODomain
//
//  Created by sean on 2022/09/19.
//

import Foundation

public protocol Parameterable where Self: Encodable {
  func toJSONString() -> String
}

public extension Parameterable {
  func toJSONString() -> String {
    do {
      let json = try JSONEncoder().encode(self)
      return String(data: json, encoding: .utf8) ?? ""
    } catch {
      print("Error: \(error.localizedDescription)")
    }
    return ""
  }
}
