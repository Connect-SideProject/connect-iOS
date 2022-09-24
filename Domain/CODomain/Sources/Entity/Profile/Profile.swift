//
//  Profile.swift
//  connect
//
//  Created by sean on 2022/07/14.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

public enum Role: String, Codable, Equatable {
  case developer = "개발자"
  case designer = "디자이너"
  case planner = "기획자"
  case marketer = "마케터"
  
  public init?(rawValue: String) {
    switch rawValue {
    case "개발자":
      self = .developer
    case "디자이너":
      self = .designer
    case "기획자":
      self = .planner
    case "마케터":
      self = .marketer
    default:
      return nil
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .developer:
      try container.encode("DEVELOPER")
    case .designer:
      try container.encode("DESIGNER")
    case .planner:
      try container.encode("PLANNER")
    case .marketer:
      try container.encode("MARKETER")
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
  
  let authType: AuthType
  let nickname: String
  let roles: [Role]
  let region: Region
  let interestings: [Interestring]
  let profileURL: String?
  let portfolioURL: String?
  let career: Career?
  let skills: [String]
  let isPushOn: Bool
  let isLocationExpose: Bool
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.authType = try container.decodeIfPresent(AuthType.self, forKey: .authType) ?? .none
    self.nickname =         try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
    self.roles =            try container.decodeIfPresent([Role].self, forKey: .roles) ?? []
    self.region =           try container.decodeIfPresent(Region.self, forKey: .region) ?? .init()
    self.interestings =     try container.decodeIfPresent([Interestring].self, forKey: .interestings) ?? []
    self.profileURL =       try container.decodeIfPresent(String.self, forKey: .profileURL)
    self.portfolioURL =     try container.decodeIfPresent(String.self, forKey: .portfolioURL)
    self.career =           try container.decodeIfPresent(Career.self, forKey: .career)
    self.skills =           try container.decodeIfPresent([String].self, forKey: .skills) ?? []
    self.isPushOn =         try container.decodeIfPresent(Bool.self, forKey: .isPushOn) ?? false
    self.isLocationExpose = try container.decodeIfPresent(Bool.self, forKey: .isLocationExpose) ?? false
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(authType, forKey: .authType)
    try container.encode(nickname, forKey: .nickname)
    try container.encode(roles, forKey: .roles)
    try container.encode(region, forKey: .region)
    try container.encode(interestings, forKey: .interestings)
    try container.encode(profileURL, forKey: .profileURL)
    try container.encode(portfolioURL, forKey: .portfolioURL)
    try container.encode(career, forKey: .career)
    try container.encode(skills, forKey: .skills)
    try container.encode(isPushOn, forKey: .isPushOn)
    try container.encode(isLocationExpose, forKey: .isLocationExpose)
  }
  
  enum CodingKeys: String, CodingKey {
    case authType = "auth_type"
    case nickname
    case roles = "role"
    case region
    case interestings = "interestings"
    case profileURL = "profile_url"
    case portfolioURL = "portfolio_url"
    case career
    case skills
    case isPushOn
    case isLocationExpose
  }
}

public extension Profile {
  init(
    authType: AuthType = .none,
    nickname: String = "",
    roles: [Role] = [],
    region: Region = .init(),
    interestings: [Interestring] = [],
    profileURL: String? = nil,
    portfolioURL: String? = nil,
    career: Career? = nil,
    skills: [String] = [],
    isPushOn: Bool = false,
    isLocationExpose: Bool = false
  ) {
    self.authType = authType
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
