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
