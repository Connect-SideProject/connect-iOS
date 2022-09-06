//
//  Path.swift
//  CONetwork
//
//  Created by sean on 2022/09/04.
//

import Foundation

import CODomain
import COExtensions

public enum Path {
  
  public var string: String {
    switch self {
    case .signIn:
      return "/api/member/auth/login"
    case .userProfile:
      return ""
    case .updateProfile(let profile):
      return ""
    }
  }
  
  public var parameter: [String: Any]? {
    switch self {
    case let .signIn(authType):
      return ["auth-type": authType.description]
    case let .updateProfile(profile):
      return profile.asDictionary()!
    default:
      return nil
    }
  }
  
  case signIn(AuthType)
  case userProfile
  case updateProfile(Codable)
}
