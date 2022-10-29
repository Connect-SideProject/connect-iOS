//
//  UIDevice+Extension.swift
//  COExtensions
//
//  Created by sean on 2022/10/26.
//

import UIKit

public extension UIDevice {
  // https://stackoverflow.com/questions/52402477/ios-detect-if-the-device-is-iphone-x-family-frameless
  var hasNotch: Bool {
    return UIApplication.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
  }
}
