//
//  SessionHeader.swift
//  CONetwork
//
//  Created by sean on 2022/10/21.
//

import Foundation

import COManager

final class SessionHeader {
  
  static let shared: SessionHeader = SessionHeader()
  
  private let userService: UserService
  
  private init(userService: UserService = UserManager.shared) {
    self.userService = userService
  }
  
  func update(headers: [AnyHashable : Any]) {
    
    let accessToken = headers["access-token"] as? String ?? ""
    let refreshToken = headers["refresh-token"] as? String ?? ""
    
    let tokens: Tokens = .init(
      access: accessToken,
      refresh: refreshToken
    )
    userService.update(tokens: tokens, profile: nil)
  }
}
