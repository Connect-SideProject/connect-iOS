//
//  ProfileEditParameter.swift
//  CODomain
//
//  Created by sean on 2022/10/09.
//

import Foundation

public struct ProfileEditParameter: Parameterable {
  
  let profileURL: String?
  let roles: [RoleType]
  var region: Region?
  let interestings: [String]
  let portfolioURL: String?
  let career: String?
  let skills: [String]
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.profileURL =   try container.decodeIfPresent(String.self, forKey: .profileURL)
    self.roles =        try container.decodeIfPresent([RoleType].self, forKey: .roles) ?? []
    self.region =       try container.decodeIfPresent(Region.self, forKey: .region) ?? .init()
    self.interestings = try container.decodeIfPresent([String].self, forKey: .interestings) ?? []
    self.portfolioURL = try container.decodeIfPresent(String.self, forKey: .portfolioURL)
    self.career =       try container.decodeIfPresent(String.self, forKey: .career)
    self.skills =       try container.decodeIfPresent([String].self, forKey: .skills) ?? []
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(profileURL, forKey: .profileURL)
    try container.encode(roles, forKey: .roles)
    try container.encode(region, forKey: .region)
    try container.encode(interestings, forKey: .interestings)
    try container.encode(portfolioURL, forKey: .portfolioURL)
    try container.encode(career, forKey: .career)
    try container.encode(skills, forKey: .skills)
  }
  
  enum CodingKeys: String, CodingKey {
    case profileURL = "profile_url"
    case roles = "role"
    case region
    case interestings = "interesting"
    case portfolioURL = "portfolio_url"
    case career
    case skills
  }
}

public extension ProfileEditParameter {
  init(
    profileURL: String? = nil,
    roles: [RoleType],
    region: Region? = nil,
    interestings: [String],
    portfolioURL: String? = nil,
    career: String? = nil,
    skills: [String]
  ) {
    self.profileURL = profileURL
    self.roles = roles
    self.region = region
    self.interestings = interestings
    self.portfolioURL = portfolioURL
    self.career = career
    self.skills = skills
  }
  
  mutating func updateRegion(_ region: Region) {
    self.region = region
  }
}
