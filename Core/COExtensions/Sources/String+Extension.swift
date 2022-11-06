//
//  String+Extension.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation
import UIKit

/// 다국어 처리.
public extension String {
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

/// AttributedText
public extension String {
  func addAttributes(_ attributes: [NSAttributedString.Key : Any], range: NSRange? = nil) -> NSAttributedString {
    let mutableString = NSMutableAttributedString(string: self)
    
    if let range = range {
      mutableString.addAttributes(attributes, range: range)
      return mutableString
    } else {
      return NSAttributedString(
        string: self,
        attributes: attributes
      )
    }
  }
}

/// AttributedText
public extension String {
  func setLastWord(color: UIColor) -> NSAttributedString {
    return self.addAttributes(
      [.foregroundColor : color],
      range: .init(location: self.count - 1, length: 1)
    )
  }
}
