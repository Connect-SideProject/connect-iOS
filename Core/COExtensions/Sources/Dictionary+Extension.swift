//
//  Dictionary+Extension.swift
//  COExtensions
//
//  Created by sean on 2022/10/20.
//

import Foundation

public extension Dictionary {
  func toJSONData() -> Data? {
    return try? JSONSerialization.data(withJSONObject: self)
  }
  
  func format(options: JSONSerialization.WritingOptions) -> Any? {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
      return try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments])
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
}
