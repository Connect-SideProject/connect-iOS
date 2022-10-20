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
  
  public private(set) var accessToken: String = ""
  
  public func update(accessToken: String?, profile: Profile?) {
    if let accessToken = accessToken {
      self.accessToken = accessToken
    }
    
    if let profile = profile {
      self.profile = profile
    }
  }
  
  public func remove() {
    self.accessToken = ""
  }
  
  public init(isExists: Bool = true) {
    self.isExists = isExists
    
    let data = JSON.profile.data(using: .utf8)!
    let profile = try? JSONDecoder().decode(Base<Profile>.self, from: data).data
    self.profile = profile
  }
}
