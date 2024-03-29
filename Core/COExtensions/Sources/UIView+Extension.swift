//
//  UIView+Extension.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

public extension UIView {
    
    public func addShadow(
        color: CGColor? = nil,
        offset: CGSize,
        radius: CGFloat? = nil,
        opacity: Float? = nil
    )  {
        self.layer.shadowColor = color
        self.layer.shadowRadius = radius ?? 0.0
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity ?? 0.0
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
}

