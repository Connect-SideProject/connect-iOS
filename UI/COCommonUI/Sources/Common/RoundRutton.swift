//
//  RoundRutton.swift
//  connect
//
//  Created by sean on 2022/07/18.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

class RoundRutton: UIButton {

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    layer.borderWidth = 1
    layer.borderColor = UIColor.lightGray.cgColor
    
    layer.cornerRadius = 8
    layer.masksToBounds = false
  }
  
  init() {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
