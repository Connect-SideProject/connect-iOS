//
//  SignUpParameter.swift
//  CODomain
//
//  Created by sean on 2022/09/19.
//

import Foundation

public struct SignUpParameter: Parameterable {
  
  var authType: AuthType?
  let nickname: String
  var region: Region?
  public let _interestings: [String]
  var interestings: [Interest] = []
  let career: Career?
  public let _roles: [RoleType]
  var roles: [Role] = []
  let profileURL: String?
  let portfolioURL: String?
  let skills: [String]
  let terms: [Terms]
  
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
    try container.encode(terms, forKey: .terms)
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
    case terms
  }
}

public extension SignUpParameter {
  init(
    authType: AuthType? = nil,
    nickname: String,
    region: Region? = nil,
    interestings: [String],
    career: Career?,
    roles: [RoleType],
    profileURL: String? = nil,
    portfolioURL: String? = nil,
    skills: [String],
    terms: [Terms]
  ) {
    self.authType = authType
    self.nickname = nickname
    self.region = region
    self._interestings = interestings
    self.career = career
    self._roles = roles
    self.profileURL = profileURL
    self.portfolioURL = portfolioURL
    self.skills = skills
    self.terms = terms
  }
  
  mutating func updateAuthType(_ authType: AuthType) {
    self.authType = authType
  }
  
  mutating func updateRegion(_ region: Region) {
    self.region = region
  }
  
  mutating func updateInterestings(_ interestings: [Interest]) {
    self.interestings = interestings
  }
  
  mutating func updateRoles(_ roles: [Role]) {
    self.roles = roles
  }
  
  func isNicknameEmpty() -> Bool {
    return nickname.isEmpty
  }
  
  func isCarrerNil() -> Bool {
    return career == nil
  }
  
  func isInterestingsEmpty() -> Bool {
    return _interestings.isEmpty
  }
  
  func isRolesEmpty() -> Bool {
    return _roles.isEmpty
  }
  
  func isSkillsEmpty() -> Bool {
    return skills.isEmpty
  }
  
  func checkedTermsCount() -> Int {
    return terms.count
  }
}
