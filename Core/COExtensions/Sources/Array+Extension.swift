//
//  Array+Extension.swift
//  COExtensions
//
//  Created by sean on 2022/09/19.
//

import Foundation

public extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}

public extension Array where Element == String {
  var toStringWithComma: String {
    return self.enumerated().reduce("") { acc, item -> String in
      return acc + ((item.offset != self.count - 1) ? "\(item.element), " : "\(item.element)")
    }
  }
    
    var toStringWithVeticalBar: String {
        return self.enumerated().reduce("") { acc, item -> String in
            return acc + ((item.offset != self.count - 1) ? "\(item.element) | " : "\(item.element)")
        }
    }

}
