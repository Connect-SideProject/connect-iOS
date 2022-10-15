//
//  Profile.swift
//  connect
//
//  Created by sean on 2022/07/14.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

public class Profile: NSObject, NSCoding, Codable {
  
  public var authType: AuthType? = nil
  public var nickname: String = ""
  public var roles: [Role] = []
  public var region: Region? = nil
  public var interestings: [String] = []
  public var profileURL: String? = nil
  public var portfolioURL: String? = nil
  public var career: Career? = nil
  public var skills: [String] = []
  
  public override init() {
    super.init()
  }
  
  required public init(from decoder: Decoder) throws {
    let container =     try decoder.container(keyedBy: CodingKeys.self)
    
    self.authType =     try container.decodeIfPresent(AuthType.self, forKey: .authType)
    self.nickname =     try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
    self.roles =        try container.decodeIfPresent([Role].self, forKey: .roles) ?? []
    self.region =       try container.decodeIfPresent(Region.self, forKey: .region) ?? .init()
    self.interestings = try container.decodeIfPresent([String].self, forKey: .interestings) ?? []
    self.profileURL =   try container.decodeIfPresent(String.self, forKey: .profileURL)
    self.portfolioURL = try container.decodeIfPresent(String.self, forKey: .portfolioURL)
    self.career =       try container.decodeIfPresent(Career.self, forKey: .career)
    self.skills =       try container.decodeIfPresent([String].self, forKey: .skills) ?? []
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
  }
  
  public required init?(coder: NSCoder) {
    let authType =      coder.decodeObject(forKey: CodingKeys.authType.rawValue) as? String ?? ""
    self.authType =     .convertType(value: authType)
    self.nickname =     coder.decodeObject(forKey: CodingKeys.nickname.rawValue) as? String ?? ""
    let roles =         coder.decodeObject(forKey: CodingKeys.roles.rawValue) as? [String] ?? []
    self.roles =        roles.compactMap { Role.convertType(value: $0) }
    self.region =       coder.decodeObject(forKey: CodingKeys.region.rawValue) as? Region ?? nil
    self.interestings = coder.decodeObject(forKey: CodingKeys.interestings.rawValue) as? [String] ?? []
    self.profileURL =   coder.decodeObject(forKey: CodingKeys.profileURL.rawValue) as? String ?? ""
    self.portfolioURL = coder.decodeObject(forKey: CodingKeys.portfolioURL.rawValue) as? String ?? ""
    let career =        coder.decodeObject(forKey: CodingKeys.career.rawValue) as? String ?? ""
    self.career =       .convertType(value: career)
    self.skills =       coder.decodeObject(forKey: CodingKeys.skills.rawValue) as? [String] ?? []
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(authType?.description, forKey: CodingKeys.authType.rawValue)
    coder.encode(nickname, forKey: CodingKeys.nickname.rawValue)
    coder.encode(roles.map { $0.rawValue }, forKey: CodingKeys.roles.rawValue)
    coder.encode(region, forKey: CodingKeys.region.rawValue)
    coder.encode(interestings, forKey: CodingKeys.interestings.rawValue)
    coder.encode(profileURL, forKey: CodingKeys.profileURL.rawValue)
    coder.encode(portfolioURL, forKey: CodingKeys.portfolioURL.rawValue)
    coder.encode(career?.rawValue, forKey: CodingKeys.career.rawValue)
    coder.encode(skills, forKey: CodingKeys.skills.rawValue)
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
  }
}

extension Profile {
  public convenience init(
    authType: AuthType? = nil,
    nickname: String = "",
    roles: [Role] = [],
    region: Region = .init(),
    interestings: [String] = [],
    profileURL: String? = nil,
    portfolioURL: String? = nil,
    career: Career? = nil,
    skills: [String] = []
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
  }
}

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

extension Role {
  static func convertType(value: String) -> Self? {
    switch value {
    case Role.developer.rawValue:
      return .developer
    case Role.designer.rawValue:
      return .designer
    case Role.planner.rawValue:
      return .planner
    case Role.marketer.rawValue:
      return .marketer
    default:
      return nil
    }
  }
}

public class Region: NSObject, NSCoding, Codable {
  
  public override var description: String {
    return name
  }
  
  var code: Int = 0
  var name: String = ""
  
  public override init() {
    super.init()
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.code = try container.decodeIfPresent(Int.self, forKey: .code) ?? 0
    self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(code, forKey: .code)
    try container.encode(name, forKey: .name)
  }
  
  public required init?(coder: NSCoder) {
    self.code = coder.decodeInteger(forKey: CodingKeys.code.rawValue)
    self.name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as? String ?? ""
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(code, forKey: CodingKeys.code.rawValue)
    coder.encode(name, forKey: CodingKeys.name.rawValue)
  }
  
  enum CodingKeys: String, CodingKey {
    case code = "regionCode"
    case name = "regionName"
  }
}

public extension Region {
  convenience init(code: Int = 0, name: String = "") {
    self.init()
    
    self.code = code
    self.name = name
  }
}
