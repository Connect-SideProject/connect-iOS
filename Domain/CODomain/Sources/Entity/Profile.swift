//
//  Profile.swift
//  connect
//
//  Created by sean on 2022/07/14.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

public enum Role: Codable, Equatable, CustomStringConvertible {
  case developer, designer, planner, marketer, none
  
  public var description: String {
    switch self {
    case .developer:
      return "developer"
    case .designer:
      return "designer"
    case .planner:
      return "planner"
    case .marketer:
      return "marketer"
    default:
      return ""
    }
  }
}

public struct Region: Codable, Equatable {
  let state: String
  let city: String
  
  public init(state: String = "", city: String = "") {
    self.state = state
    self.city = city
  }
}

public struct Profile: Codable, Equatable {
  
  let profileURL: String
  let nickname: String
  let roles: [Role]
  let region: Region
  let interestings: [String]
  let portfolioURL: String?
  let career: String
  let skills: [String]
  let isPushOn: Bool
  let isLocationExpose: Bool
  
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.profileURL =       try container.decodeIfPresent(String.self, forKey: .profileURL) ?? ""
    self.nickname =         try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
    self.roles =            try container.decodeIfPresent([Role].self, forKey: .roles) ?? []
    self.region =           try container.decodeIfPresent(Region.self, forKey: .region) ?? .init()
    self.interestings =     try container.decodeIfPresent([String].self, forKey: .interestings) ?? []
    self.portfolioURL =     try container.decodeIfPresent(String.self, forKey: .portfolioURL) ?? nil
    self.career =           try container.decodeIfPresent(String.self, forKey: .career) ?? ""
    self.skills =           try container.decodeIfPresent([String].self, forKey: .skills) ?? []
    self.isPushOn =         try container.decodeIfPresent(Bool.self, forKey: .isPushOn) ?? false
    self.isLocationExpose = try container.decodeIfPresent(Bool.self, forKey: .isLocationExpose) ?? false
  }
  
  enum CodingKeys: String, CodingKey {
    case profileURL = "profile_url"
    case nickname
    case roles = "role"
    case region
    case interestings = "interestings"
    case portfolioURL = "portfolio_url"
    case career
    case skills
    case isPushOn
    case isLocationExpose
  }
}

public extension Profile {
  init(
    profileURL: String = "",
    nickname: String = "",
    roles: [Role] = [],
    region: Region = .init(),
    interestings: [String] = [],
    portfolioURL: String? = nil,
    career: String = "",
    skills: [String] = [],
    isPushOn: Bool = false,
    isLocationExpose: Bool = false
  ) {
    self.profileURL = profileURL
    self.nickname = nickname
    self.roles = roles
    self.region = region
    self.interestings = interestings
    self.portfolioURL = portfolioURL
    self.career = career
    self.skills = skills
    self.isPushOn = isPushOn
    self.isLocationExpose = isLocationExpose
  }
}
