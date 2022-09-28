//
//  SignUpParameter.swift
//  CODomain
//
//  Created by sean on 2022/09/19.
//

import Foundation

public struct SignUpParameter: Parameterable {
  
  let authType: AuthType?
  let nickname: String
  let region: Region
  let interestings: [Interestring]
  let career: Career?
  let roles: [Role]
  let profileURL: String?
  let portfolioURL: String?
  let skills: [String]
  let terms: [Terms]
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.authType =     try container.decodeIfPresent(AuthType.self, forKey: .authType)
    self.nickname =     try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
    self.roles =        try container.decodeIfPresent([Role].self, forKey: .roles) ?? []
    self.region =       try container.decodeIfPresent(Region.self, forKey: .region) ?? .init()
    self.interestings = try container.decodeIfPresent([Interestring].self, forKey: .interestings) ?? []
    self.profileURL =   try container.decodeIfPresent(String.self, forKey: .profileURL)
    self.portfolioURL = try container.decodeIfPresent(String.self, forKey: .portfolioURL)
    self.career =       try container.decodeIfPresent(Career.self, forKey: .career)
    self.skills =       try container.decodeIfPresent([String].self, forKey: .skills) ?? []
    self.terms =        try container.decodeIfPresent([Terms].self, forKey: .terms) ?? []
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
    case terms
  }
}

public extension SignUpParameter {
  init(authType: AuthType, nickname: String, region: Region, interestings: [Interestring], career: Career?, roles: [Role], profileURL: String? = nil, portfolioURL: String? = nil, skills: [String], terms: [Terms]) {
    self.authType = authType
    self.nickname = nickname
    self.region = region
    self.interestings = interestings
    self.career = career
    self.roles = roles
    self.profileURL = profileURL
    self.portfolioURL = portfolioURL
    self.skills = skills
    self.terms = terms
  }
}
