//
//  EndPoint.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import COAuth
import COManager

public enum HTTPMethod {
  case get, post, put, delete

  var string: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .put:
      return "PUT"
    case .delete:
      return "DELETE"
    }
  }
}

public struct EndPoint {
  
  public let path: Path
  private let tokens: Tokens
  
  public init(path: Path, userService: UserService = UserManager.shared) {
    self.path = path
    self.tokens = userService.tokens
  }
}

public extension EndPoint {
  
  var baseURL: URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "contpass.site"
    return components.url!
  }
  
  var header: [String: String]? {
    var common: [String: String] = ["Content-Type": "application/json"]
    switch path {
    case let .signIn(authType, accessToken):
      let _ = ["access-token": accessToken,
               "auth-type": authType.description].map { common[$0.key] = $0.value }
      
    case let .signUp(_, accessToken):
      let _ = ["access-token": accessToken].map { common[$0.key] = $0.value }
      
    case .serchPlace:
      return ["Authorization": Auth.ThirdParty.kakao]
      
    case .interests, .skills:
      break
    
    case .uploadProfileImage:
      return ["Content-Type": "multipart/form-data"]
      
    default:
      let _ = [
        "access-token": tokens.access,
        "refresh-token": tokens.refresh
      ].map { common[$0.key] = $0.value }
    }
    return common
  }

  var url: URL? {

    var components = URLComponents()
    components.scheme = baseURL.scheme
    components.host = baseURL.host
    components.path = path.string
    
    switch path {
    case .serchPlace(let query):
      components.host = "dapi.kakao.com"
      components.queryItems = [URLQueryItem(name: "query", value: query)]
    default:
      break
    }
    
    return components.url
  }

  var parameter: [String: Any]? {
    return path.parameter
  }

  var method: HTTPMethod {
    switch path {
    case .signUp, .uploadProfileImage, .userProfile, .updateProfile:
      return .put
    case .signIn:
      return .post
    default:
      return .get
    }
  }
}
