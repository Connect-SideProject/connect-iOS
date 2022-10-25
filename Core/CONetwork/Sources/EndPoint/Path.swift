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
  case skills
  case interests
  case signIn(AuthType, String)
  case signUp(SignUpParameter, String)
  case serchPlace(String)
  case uploadProfileImage(Data)
  case userProfile
  case homeMenu
  case updateProfile(ProfileEditParameter)
  
  public var string: String {
    switch self {
    case .skills:
      return "/api/member/code/roleAndSkill/all"
    case .interests:
      return "/api/member/code/interest/all"
    case .signIn:
      return "/api/member/auth/login"
    case .signUp:
      return "/api/member/auth/signup"
    case .serchPlace:
      return "/v2/local/search/address.json"
    case .homeMenu:
        return "/api/study/home/menu"
    case .uploadProfileImage:
      return "/api/member/myPage/profile"
    case .userProfile, .updateProfile:
      return "/api/member/myPage/detail"
    }
  }
  
  public var parameter: [String: Any]? {
    switch self {
    case let .signUp(parameter, _):
      return parameter.asDictionary()
    case let .updateProfile(parameter):
      return parameter.asDictionary()
    default:
      return nil
    }
  }
}
