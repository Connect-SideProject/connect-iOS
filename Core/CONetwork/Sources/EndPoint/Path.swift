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
  case allSkills
  case signIn(AuthType, String)
  case signUp(SignUpParameter)
  case serchPlace(String)
  case userProfile
  case updateProfile(Codable)
  
  public var string: String {
    switch self {
    case .allSkills:
      return "/api/member/code/roleAndSkill/all"
    case .signIn:
      return "/api/member/auth/login"
    case .signUp:
      return "/api/member/auth/signup"
    case .serchPlace:
      return "/v2/local/search/address.json"
    case .userProfile:
      return ""
    case .updateProfile:
      return ""
    }
  }
  
  public var parameter: [String: Any]? {
    switch self {
    case let .signUp(parameter):
      return parameter.asDictionary()
    case let .updateProfile(profile):
      return profile.asDictionary()
    default:
      return nil
    }
  }
}
