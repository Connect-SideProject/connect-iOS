//
//  FlexLayout+Extension.swift
//  COCommonUI
//
//  Created by sean on 2022/12/03.
//

import UIKit

import FlexLayout
import PinLayout

public enum FlexDirection {
  case horizontal, vertical
}

public extension Flex {
  func spacer() {
    addItem().grow(1)
  }
  
  func separator(
    direction: FlexDirection,
    value: CGFloat,
    backgroundColor: UIColor
  ) {
    if direction == .horizontal {
      addItem()
        .backgroundColor(backgroundColor)
        .width(value)
    } else {
      addItem()
        .backgroundColor(backgroundColor)
        .height(value)
    }
  }
}
