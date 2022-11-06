//
//  InterestService.swift
//  COManager
//
//  Created by sean on 2022/10/20.
//

import Foundation

import CODomain

public protocol InterestService {
  var isExists: Bool { get }
  
  var interestList: [Interest] { get }
  
  func update(_ interestList: [Interest])
}
