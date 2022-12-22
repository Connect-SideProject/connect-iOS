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
  case createMeeting(CreateMeetingParameter)
  case search([String:String]?)
  case uploadProfileImage(Data)
  case userProfile
  case homeNews([String:String?])
  case homeBookMark(String)
  case updateProfile(ProfileEditParameter)
  case homeRelease
  case refreshToken
  case logout
  case signOut
  case getWhoMarker
  case getStudyInfo(Int)
  
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
    case .createMeeting:
      return "/api/study"
    case .homeNews:
      return "/api/study/news"
    case .homeRelease:
      return "/api/study/hots"
    case let .homeBookMark(id):
        return "/api/study/\(id)/bookmark"
    case .search:
        return "/api/study/search"
    case .uploadProfileImage:
      return "/api/member/myPage/profile"
    case .userProfile, .updateProfile:
      return "/api/member/myPage/detail"
    case .refreshToken:
      return "/api/member/issue/token/refresh"
    case .logout:
      return "/api/member/auth/logout"
    case .signOut:
      return "/api/member/auth/signout"
    case .getWhoMarker:
        return "/api/study/map"
    case .getStudyInfo(let regionID):
        return "/api/study/map/\(regionID)"
    }
  }
  
  public var parameter: [String: Any]? {
    switch self {
    case let .signUp(parameter, _):
      return parameter.asDictionary()
    case let .updateProfile(parameter):
      return parameter.asDictionary()
    case let .createMeeting(parameter):
      return parameter.asDictionary()
    default:
      return nil
    }
  }
}
