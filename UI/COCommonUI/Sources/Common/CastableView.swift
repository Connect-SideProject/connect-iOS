//
//  CastableView.swift
//  COCommonUI
//
//  Created by sean on 2022/09/28.
//

import Foundation
import UIKit

public protocol CastableView where Self: UIView {
  func casting<T: UIView>(type: T.Type) -> T
}

public extension CastableView {
  func casting<T: UIView>(type: T.Type) -> T {
    if let view = self as? T {
      return view
    }
    
    fatalError("잘못된 Type Casting!")
  }
}
