//
//  InterestManagerStub.swift
//  COManager
//
//  Created by sean on 2022/10/20.
//

import Foundation

import CODomain

public final class InterestManagerStub: InterestService {
  public var isExists: Bool
  
  public var interestList: [CODomain.Interest] {
    let data = JSON.interests.data(using: .utf8)!
    return try! JSONDecoder().decode(Base<[Interest]>.self, from: data).data ?? []
  }
  
  public init(isExists: Bool) {
    self.isExists = isExists
  }
  
  public func update(_ interestList: [CODomain.Interest]) {
    
  }
}
