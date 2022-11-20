//
//  RoundRutton.swift
//  connect
//
//  Created by sean on 2022/07/18.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

public final class RoundRutton: UIButton {

  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    layer.borderWidth = 1
    layer.borderColor = borderColor?.cgColor
    
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = true
  }
  
  private let cornerRadius: CGFloat
  private let borderColor: UIColor?
  
  public init(cornerRadius: CGFloat = 8, borderColor: UIColor? = nil) {
    self.cornerRadius = cornerRadius
    self.borderColor = borderColor
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
