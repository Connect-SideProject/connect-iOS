//
//  Encodable+Extension.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

public extension Encodable {
  func asDictionary() -> [String: Any]? {
    do {
      let json = try JSONEncoder().encode(self)
      let dict = try JSONSerialization.jsonObject(
        with: json,
        options: .allowFragments
      ) as? [String: Any]
      return dict
    } catch let error {
      print(error)
      return nil
    }
  }
}
