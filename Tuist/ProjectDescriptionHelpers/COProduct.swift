//
//  COProduct.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/09/05.
//

import Foundation

public enum ProductState {
  case `static`, `dynamic`
}

public enum COProduct: Equatable {
  
  var isLibrary: Bool {
    return (self == .library(.static) || self == .library(.dynamic))
  }
  
  var isFramework: Bool {
    return (self == .framework(.static) || self == .framework(.dynamic))
  }
  
  /// 앱.
  case app
  
  /// 데모 앱.
  case demoApp
  
  case library(ProductState)
  
  case framework(ProductState)
  
  case tests
  case unitTests
  case uiTests
  
  case bundle
}
