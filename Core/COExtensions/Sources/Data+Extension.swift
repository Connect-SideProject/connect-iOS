//
//  Data+Extension.swift
//  COExtensions
//
//  Created by sean on 2022/10/20.
//

import Foundation

public extension Data {
  func toJSONString() -> String {
    if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
      return String(data: jsonData, encoding: .utf8) ?? ""
    }
    
    return ""
  }
    
    func decode<T: Decodable>() -> T? {
        if let json = try? JSONDecoder().decode(T.self, from: self) {
            return json
        }
        return nil
    }
}
