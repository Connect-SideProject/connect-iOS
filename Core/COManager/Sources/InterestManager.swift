//
//  InterestManager.swift
//  COManager
//
//  Created by sean on 2022/10/20.
//

import Foundation

import CODomain
import COExtensions

public final class InterestManager: InterestService {
  
  public static let shared: InterestManager = InterestManager()
  
  public var isExists: Bool {
    return UserDefaults.standard.isExists(forKey: .interestList)
  }
  
  public var interestList: [Interest] {
    return UserDefaults.standard.object(type: [Interest].self, forKey: .interestList) ?? []
  }
  
  private init() {}
  
  public func update(_ interestList: [Interest]) {
    UserDefaults.standard.set(object: interestList, forKey: .interestList)
  }
}
