//
//  Profile.swift
//  connect
//
//  Created by sean on 2022/07/14.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

public enum Role: String, Codable, Equatable, CustomStringConvertible {
  case developer = "개발자"
  case designer = "디자이너"
  case planner = "기획자"
  case marketer = "마케터"
  
  public var description: String {
    return self.rawValue
  }
  
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
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer().decode(String.self)
    
    switch container {
    case "DEV":
      self = .developer
    case "DESIGN":
      self = .designer
    case "PM":
      self = .planner
    case "MAK":
      self = .marketer
    default:
      fatalError("")
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .developer:
      try container.encode("DEV")
    case .designer:
      try container.encode("DESIGN")
    case .planner:
      try container.encode("PM")
    case .marketer:
      try container.encode("MAK")
    }
  }
}

public struct Region: Codable, Equatable, CustomStringConvertible {
  
  public var description: String {
    return name
  }
  
  let code: String
  let name: String
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
    self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(code, forKey: .code)
    try container.encode(name, forKey: .name)
  }
  
  enum CodingKeys: String, CodingKey {
    case code = "regionCode"
    case name = "regionName"
  }
}

public extension Region {
  init(code: String = "", name: String = "") {
    self.code = code
    self.name = name
  }
}

public class Profile: NSObject, NSCoding, Codable {
  
  var authType: AuthType? = nil
  public var nickname: String = ""
  public var roles: [Role] = []
  public var region: Region? = nil
  public var interestings: [Interestring] = []
  public var profileURL: String? = nil
  public var portfolioURL: String? = nil
  public var career: Career? = nil
  public var skills: [String] = []
  var isPushOn: Bool = false
  var isLocationExpose: Bool = false
  
  public override init() {
    super.init()
  }
  
  required public init(from decoder: Decoder) throws {
    let container =         try decoder.container(keyedBy: CodingKeys.self)
    
    self.authType =         try container.decodeIfPresent(AuthType.self, forKey: .authType)
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
  
  public required init?(coder: NSCoder) {
    self.authType =         coder.decodeObject(forKey: CodingKeys.authType.rawValue) as? AuthType
    self.nickname =         coder.decodeObject(forKey: CodingKeys.nickname.rawValue) as? String ?? ""
    self.roles =            coder.decodeObject(forKey: CodingKeys.roles.rawValue) as? [Role] ?? []
    self.region =           coder.decodeObject(forKey: CodingKeys.region.rawValue) as? Region ?? nil
    self.interestings =     coder.decodeObject(forKey: CodingKeys.interestings.rawValue) as? [Interestring] ?? []
    self.profileURL =       coder.decodeObject(forKey: CodingKeys.profileURL.rawValue) as? String ?? ""
    self.portfolioURL =     coder.decodeObject(forKey: CodingKeys.portfolioURL.rawValue) as? String ?? ""
    self.career =           coder.decodeObject(forKey: CodingKeys.career.rawValue) as? Career ?? nil
    self.skills =           coder.decodeObject(forKey: CodingKeys.skills.rawValue) as? [String] ?? []
    self.isPushOn =         coder.decodeBool(forKey: CodingKeys.isPushOn.rawValue)
    self.isLocationExpose = coder.decodeBool(forKey: CodingKeys.isLocationExpose.rawValue)
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(authType, forKey: CodingKeys.authType.rawValue)
    coder.encode(nickname, forKey: CodingKeys.nickname.rawValue)
    coder.encode(roles, forKey: CodingKeys.roles.rawValue)
    coder.encode(region, forKey: CodingKeys.region.rawValue)
    coder.encode(interestings, forKey: CodingKeys.interestings.rawValue)
    coder.encode(profileURL, forKey: CodingKeys.profileURL.rawValue)
    coder.encode(portfolioURL, forKey: CodingKeys.portfolioURL.rawValue)
    coder.encode(career, forKey: CodingKeys.career.rawValue)
    coder.encode(skills, forKey: CodingKeys.skills.rawValue)
    coder.encode(isPushOn, forKey: CodingKeys.isPushOn.rawValue)
    coder.encode(isLocationExpose, forKey: CodingKeys.isLocationExpose.rawValue)
  }
  
  enum CodingKeys: String, CodingKey {
    case authType = "auth_type"
    case nickname
    case roles = "role"
    case region
    case interestings = "interesting"
    case profileURL = "profile_url"
    case portfolioURL = "portfolio_url"
    case career
    case skills
    case isPushOn
    case isLocationExpose
  }
}

extension Profile {
  public convenience init(
    authType: AuthType? = nil,
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
    self.init()
    
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
