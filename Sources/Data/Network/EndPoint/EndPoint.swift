//
//  EndPoint.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

enum PathType {
  case userProfile
  case updateProfile(Profile)
}

enum HTTPMethod {
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

struct EndPoint {
  private var baseURL: URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = ""
    return components.url!
  }
  
  let path: PathType
  
  init(path: PathType) {
    self.path = path
  }
}

extension EndPoint {
  
  var header: [String: String]? {
    return ["Authorization": UserManager.shared.accessToken]
  }
  
  var url: URL? {
    
    var components = URLComponents()
    components.scheme = baseURL.scheme
    components.host = baseURL.host
    
    var queryItems: [URLQueryItem] = []
    
    switch path {
    case .userProfile:
      components.path = ""
    case .updateProfile:
      components.path = ""
    }
    
    components.queryItems = queryItems
    
    return components.url
  }
  
  var parameter: [String: Any]? {
    switch path {
    case let .updateProfile(profile):
      return profile.asDictionary()!
    default:
      return nil
    }
  }
  
  var method: HTTPMethod {
    return .get
  }
}
