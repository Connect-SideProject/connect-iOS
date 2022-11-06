//
//  UserManagerStub.swift
//  COManager
//
//  Created by sean on 2022/09/05.
//

import Foundation

import CODomain

public final class UserManagerStub: UserService {
  
  public private(set) var isExists: Bool
  
  public private(set) var profile: CODomain.Profile? = nil
  
  public var tokens: Tokens = .init()
  
  public func update(tokens: Tokens?, profile: CODomain.Profile?) {
    if let tokens = tokens {
      self.tokens = tokens
    }
    
    if let profile = profile {
      self.profile = profile
    }
  }
  
  public func remove() {
    self.tokens = .init()
  }
  
  public init(isExists: Bool = true) {
    self.isExists = isExists
    
    let data = JSON.profile.data(using: .utf8)!
    let profile = try? JSONDecoder().decode(Base<Profile>.self, from: data).data
    self.profile = profile
  }
}
