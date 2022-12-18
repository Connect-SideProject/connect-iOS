//
//  Color+Extension.swift
//  COCommonUI
//
//  Created by sean on 2022/10/25.
//

import UIKit

public extension UIColor {
  static let hexEFFFF6: UIColor = .init(hex: "#EFFFF6")
  static let hexD4F6E2: UIColor = .init(hex: "#D4F6E2")
  static let hex97E0C5: UIColor = .init(hex: "#97E0C5")
  static let hex06C755: UIColor = .init(hex: "#06C755")
  static let hex05A647: UIColor = .init(hex: "#05A647")
  static let hex639200: UIColor = .init(hex: "#639200")
  static let hex028236: UIColor = .init(hex: "#028236")
  
  static let hexF9F9F9: UIColor = .init(hex: "#F9F9F9")
  static let hexEDEDED: UIColor = .init(hex: "#EDEDED")
  static let hexC6C6C6: UIColor = .init(hex: "#C6C6C6")
  static let hex8E8E8E: UIColor = .init(hex: "#8E8E8E")
  static let hex5B5B5B: UIColor = .init(hex: "#5B5B5B")
  static let hex3A3A3A: UIColor = .init(hex: "#3A3A3A")
  static let hex141616: UIColor = .init(hex: "#141616")
  static let hex818181: UIColor = .init(hex: "#818181")
}

public extension UIColor {
  convenience init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt64()
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }
}
