//
//  String+Extension.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

/// 다국어 처리.
extension String {
  func localized(comment: String = "") -> String {
    let currentLanguage = Locale.current.languageCode
    let path = Bundle.main.path(
      forResource: currentLanguage,
      ofType: "lproj"
    )
    let bundle = Bundle(path: path!)
    
    return NSLocalizedString(self, bundle: bundle!, value: "", comment: "")
  }
  
  func localized(with argument: CVarArg = [], comment: String = "") -> String {
    return String(format: self.localized(comment: comment), argument)
  }
}
