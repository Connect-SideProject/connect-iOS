//
//  UITableViewCell+Extension.swift
//  COExtensions
//
//  Created by Taeyoung Son on 2022/11/02.
//

import UIKit

public extension UITableViewCell {
    static var reuseableIdentifier: String {
        get {
            return NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
        }
    }
}
