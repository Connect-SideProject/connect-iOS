//
//  UserManager.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

protocol UserService {
  var accessToken: String { get }
}

class UserManager: UserService {
  
  static let shared: UserManager = UserManager()
  
  var accessToken: String {
    return UserDefaults.standard.string(forKey: .accessToken)
  }
  
  private init() {}
}
