//
//  UserManagerStub.swift
//  COManager
//
//  Created by sean on 2022/09/05.
//

import Foundation

public final class UserManagerStub: UserService {
  
  public private(set) var accessToken: String = ""
  
  public func update(accessToken: String) {
    self.accessToken = accessToken
  }
  
  public func remove() {
    self.accessToken = ""
  }
  
  public init() {
    
  }
}
