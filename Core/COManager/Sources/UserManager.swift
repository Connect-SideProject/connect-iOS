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
    return UserDefaults.standard.isExists(forKey: .accessToken) &&
    UserDefaults.standard.isExists(forKey: .refreshToken)
  }
  
  public var tokens: Tokens {
    return .init(
      access: UserDefaults.standard.string(forKey: .accessToken),
      refresh: UserDefaults.standard.string(forKey: .refreshToken)
    )
  }
  
  public var profile: Profile? {
    return UserDefaults.standard.object(type: Profile.self, forKey: .profile)
  }
  
  private init() {}
  
  public func update(tokens: Tokens?, profile: Profile?) {
  
    if let tokens = tokens {
      UserDefaults.standard.set(tokens.access, forKey: .accessToken)
      UserDefaults.standard.set(tokens.refresh, forKey: .refreshToken)
    }
  
    if let profile = profile {
      UserDefaults.standard.set(object: profile, forKey: .profile)
    }
  }
  
  public func remove() {
    UserDefaults.standard.remove(forKey: .accessToken)
    UserDefaults.standard.remove(forKey: .refreshToken)
    UserDefaults.standard.remove(forKey: .profile)
  }
}
