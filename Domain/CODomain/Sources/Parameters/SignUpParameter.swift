//
//  SignUpParameter.swift
//  CODomain
//
//  Created by sean on 2022/09/19.
//

import Foundation

public struct SignUpParameter: Parameterable {
  
  let authType: AuthType
  let nickname: String
  let region: Region
  let interesting: [Interestring]
  let career: Career
  let role: [Role]
  let profileURL: String?
  let portfolioURL: String?
  let skills: [String]
  let terms: [Terms]
  
  public init(authType: AuthType, nickname: String, region: Region, interesting: [Interestring], career: Career, role: [Role], profileURL: String? = nil, portfolioURL: String? = nil, skills: [String], terms: [Terms]) {
    self.authType = authType
    self.nickname = nickname
    self.region = region
    self.interesting = interesting
    self.career = career
    self.role = role
    self.profileURL = profileURL
    self.portfolioURL = portfolioURL
    self.skills = skills
    self.terms = terms
  }
}
