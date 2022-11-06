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
  public var interestings: [Interest] = []
  public var profileURL: String? = nil
  public var portfolioURL: String? = nil
  public var career: Career? = nil
  public var skills: [String] = []
  public var isPushOn: BooleanState? = .no
  public var isActiveOpen: BooleanState? = .no
  
  public override init() {
    super.init()
  }
  
  required public init(from decoder: Decoder) throws {
    let container =     try decoder.container(keyedBy: CodingKeys.self)
    
    self.authType =     try container.decodeIfPresent(AuthType.self, forKey: .authType)
    self.nickname =     try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
    self.roles =        try container.decodeIfPresent([Role].self, forKey: .roles) ?? []
    self.region =       try container.decodeIfPresent(Region.self, forKey: .region) ?? .init()
    self.interestings = try container.decodeIfPresent([Interest].self, forKey: .interestings) ?? []
    self.profileURL =   try container.decodeIfPresent(String.self, forKey: .profileURL)
    self.portfolioURL = try container.decodeIfPresent(String.self, forKey: .portfolioURL)
    self.career =       try container.decodeIfPresent(Career.self, forKey: .career)
    self.skills =       try container.decodeIfPresent([String].self, forKey: .skills) ?? []
    self.isPushOn =     try container.decodeIfPresent(BooleanState.self, forKey: .isPushOn) ?? .no
    self.isActiveOpen = try container.decodeIfPresent(BooleanState.self, forKey: .isActiveOpen) ?? .no
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
    try container.encode(isActiveOpen, forKey: .isActiveOpen)
  }
  
  public required init?(coder: NSCoder) {
    let authType =      coder.decodeObject(forKey: CodingKeys.authType.rawValue) as? String ?? ""
    self.authType =     .convertType(value: authType)
    self.nickname =     coder.decodeObject(forKey: CodingKeys.nickname.rawValue) as? String ?? ""
    self.roles =        coder.decodeObject(forKey: CodingKeys.roles.rawValue) as? [Role] ?? []
    self.region =       coder.decodeObject(forKey: CodingKeys.region.rawValue) as? Region ?? nil
    self.interestings = coder.decodeObject(forKey: CodingKeys.interestings.rawValue) as? [Interest] ?? []
    self.profileURL =   coder.decodeObject(forKey: CodingKeys.profileURL.rawValue) as? String ?? ""
    self.portfolioURL = coder.decodeObject(forKey: CodingKeys.portfolioURL.rawValue) as? String ?? ""
    let career =        coder.decodeObject(forKey: CodingKeys.career.rawValue) as? String ?? ""
    self.career =       .convertType(value: career)
    self.skills =       coder.decodeObject(forKey: CodingKeys.skills.rawValue) as? [String] ?? []
    let isPushOn =      coder.decodeObject(forKey: CodingKeys.isPushOn.rawValue) as? String ?? ""
    self.isPushOn =     .convertType(value: isPushOn)
    let isActiveOpen =  coder.decodeObject(forKey: CodingKeys.isActiveOpen.rawValue) as? String ?? ""
    self.isActiveOpen = .convertType(value: isActiveOpen)
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(authType?.description, forKey: CodingKeys.authType.rawValue)
    coder.encode(nickname, forKey: CodingKeys.nickname.rawValue)
    coder.encode(roles, forKey: CodingKeys.roles.rawValue)
    coder.encode(region, forKey: CodingKeys.region.rawValue)
    coder.encode(interestings, forKey: CodingKeys.interestings.rawValue)
    coder.encode(profileURL, forKey: CodingKeys.profileURL.rawValue)
    coder.encode(portfolioURL, forKey: CodingKeys.portfolioURL.rawValue)
    coder.encode(career?.rawValue, forKey: CodingKeys.career.rawValue)
    coder.encode(skills, forKey: CodingKeys.skills.rawValue)
    coder.encode(isPushOn?.rawValue, forKey: CodingKeys.isPushOn.rawValue)
    coder.encode(isActiveOpen?.rawValue, forKey: CodingKeys.isActiveOpen.rawValue)
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
    case isPushOn = "push_yn"
    case isActiveOpen = "active_open_yn"
  }
}

extension Profile {
  public convenience init(
    authType: AuthType? = nil,
    nickname: String = "",
    roles: [Role] = [],
    region: Region = .init(),
    interestings: [Interest] = [],
    profileURL: String? = nil,
    portfolioURL: String? = nil,
    career: Career? = nil,
    skills: [String] = [],
    isPushOn: BooleanState = .no,
    isActiveOpen: BooleanState = .no
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
    self.isActiveOpen = isActiveOpen
  }
}

public enum BooleanState: String, Codable {
  case yes = "Y", no = "N"
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer().decode(String.self)
    
    switch container {
    case "Y":
      self = .yes
    default:
      self = .no
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .yes:
      try container.encode("Y")
    default:
      try container.encode("N")
    }
  }
}

extension BooleanState {
  static func convertType(value: String) -> Self? {
    switch value {
    case "Y":
      return .yes
    default:
      return .no
    }
  }
}

public class Role: NSObject, NSCoding, Codable, Identifiable {
  
  public override var description: String {
    return name
  }
  
  public var id: Int = -1
  public var type: RoleType?
  public var name: String = ""
  
  public override init() {
    super.init()
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id =   try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
    self.type = try container.decodeIfPresent(RoleType.self, forKey: .type)
    self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(id, forKey: .id)
    try container.encode(type, forKey: .type)
    try container.encode(name, forKey: .name)
  }
  
  public required init?(coder: NSCoder) {
    let type =  coder.decodeObject(forKey: CodingKeys.type.rawValue) as? String ?? ""
    self.id =   coder.decodeInteger(forKey: CodingKeys.id.rawValue)
    self.type = .convertType(value: type)
    self.name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as? String ?? ""
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(id, forKey: CodingKeys.id.rawValue)
    coder.encode(type?.rawValue, forKey: CodingKeys.type.rawValue)
    coder.encode(name, forKey: CodingKeys.name.rawValue)
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "sort_num"
    case type = "code_cd"
    case name = "code_nm"
  }
}

public extension Role {
  convenience init(type: RoleType? = nil) {
    self.init()
    
    self.type = type
    self.name = type?.description ?? ""
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    return type == (object as? Role)?.type
  }
}

public enum RoleType: String, Codable, Equatable, CustomStringConvertible {
  case developer = "DEV"
  case designer = "DESIGN"
  case planner = "PM"
  case marketer = "MAK"
  
  public var description: String {
    switch self {
    case .developer:
      return "개발자"
    case .designer:
      return "디자이너"
    case .planner:
      return "기획자"
    case .marketer:
      return "마케터"
    }
  }
  
  public init?(rawValue: String) {
    switch rawValue {
    case "DEV":
      self = .developer
    case "DESIGN":
      self = .designer
    case "PM":
      self = .planner
    case "MAK":
      self = .marketer
    default:
      return nil
    }
  }
  
  public init?(description: String) {
    switch description {
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

extension RoleType {
  static func convertType(value: String) -> Self? {
    switch value {
    case RoleType.developer.rawValue:
      return .developer
    case RoleType.designer.rawValue:
      return .designer
    case RoleType.planner.rawValue:
      return .planner
    case RoleType.marketer.rawValue:
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

public class Interest: NSObject, NSCoding, Codable, Identifiable {
  
  public override var description: String {
    return name
  }
  
  public var id: Int = 0
  public var code: String = ""
  public var name: String = ""
  
  public override init() {
    super.init()
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id =   try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
    self.code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
    self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(id, forKey: .id)
    try container.encode(code, forKey: .code)
    try container.encode(name, forKey: .name)
  }
  
  public required init?(coder: NSCoder) {
    self.id =   coder.decodeInteger(forKey: CodingKeys.id.rawValue)
    self.code = coder.decodeObject(forKey: CodingKeys.code.rawValue) as? String ?? ""
    self.name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as? String ?? ""
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(id, forKey: CodingKeys.id.rawValue)
    coder.encode(code, forKey: CodingKeys.code.rawValue)
    coder.encode(name, forKey: CodingKeys.name.rawValue)
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "sort_num"
    case code = "code_cd"
    case name = "code_nm"
  }
}

public extension Interest {
  convenience init(code: String = "", name: String = "") {
    self.init()
//    self.id = -1
    self.code = code
    self.name = name
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    return code == (object as? Interest)?.code
  }
}
