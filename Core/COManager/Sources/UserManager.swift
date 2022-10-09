//
//  UserManager.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import CODomain
import COExtensions

public final class UserManager: UserService {
  
  public static let shared: UserManager = UserManager()
  
  public var isExists: Bool {
    return UserDefaults.standard.isExists(forKey: .accessToken)
  }
  
  public var accessToken: String {
    return UserDefaults.standard.string(forKey: .accessToken)
  }
  
  public var profile: Profile? {
    return UserDefaults.standard.object(type: Profile.self, forKey: .profile)
  }
  
  private init() {}
  
  public func update(accessToken: String) {
    UserDefaults.standard.set(accessToken, forKey: .accessToken)
  }
  
  public func update(profile: Profile) {
    UserDefaults.standard.set(object: profile, forKey: .profile)
  }
  
  public func remove() {
    UserDefaults.standard.remove(forKey: .accessToken)
    UserDefaults.standard.remove(forKey: .profile)
  }
}
