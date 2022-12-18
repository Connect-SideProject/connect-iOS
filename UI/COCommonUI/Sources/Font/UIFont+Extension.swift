//
//  UIFont+Extension.swift
//  COCommonUI
//
//  Created by sean on 2022/10/25.
//

import UIKit

public extension UIFont {
  static func light(size: CGFloat) -> Self {
    return .init(name: "AppleSDGothicNeo-Light", size: size)!
  }
  
  static func regular(size: CGFloat) -> Self {
    return .init(name: "AppleSDGothicNeo-Regular", size: size)!
  }
  
  static func medium(size: CGFloat) -> Self {
    return .init(name: "AppleSDGothicNeo-Regular", size: size)!
  }
  
  static func semiBold(size: CGFloat) -> Self {
    return .init(name: "AppleSDGothicNeo-Semibold", size: size)!
  }
  
  static func bold(size: CGFloat) -> Self {
    return .init(name: "AppleSDGothicNeo-Bold", size: size)!
  }
}
