//
//  AttributedString+Extension.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/04.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    func setAttributed(key: NSAttributedString.Key, value: Any, compare: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(key, value: value, range: (string as NSString).range(of: compare))
        
        return attributedString
    }
}
