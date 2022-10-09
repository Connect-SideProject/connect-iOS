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
  
  public func update(accessToken: String) {
    self.accessToken = accessToken
  }
  
  public func update(profile: Profile) {
    self.profile = profile
  }
  
  public func remove() {
    self.accessToken = ""
  }
  
  public init(isExists: Bool = true) {
    self.isExists = isExists
  }
}
