//
//  Profile.swift
//  connect
//
//  Created by sean on 2022/07/14.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

enum JobGroup: Codable, Equatable, CustomStringConvertible {
  case developer, designer, planner, marketer, none
  
  var description: String {
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

struct Profile: Decodable, Equatable {
  
  let profileURL: String
  let userName: String
  let jobGroup: JobGroup
  let location: String
  let attentions: String
  let portfolioURL: String
  let career: String
  let skills: [String]
  let isPushOn: Bool
  let isLocationExpose: Bool
  
  internal init(
    profileURL: String = "",
    userName: String = "",
    jobGroup: JobGroup = .none,
    location: String = "",
    attentions: String = "",
    portfolioURL: String = "",
    career: String = "",
    skills: [String] = [],
    isPushOn: Bool = false,
    isLocationExpose: Bool = false
  ) {
    self.profileURL = profileURL
    self.userName = userName
    self.jobGroup = jobGroup
    self.location = location
    self.attentions = attentions
    self.portfolioURL = portfolioURL
    self.career = career
    self.skills = skills
    self.isPushOn = isPushOn
    self.isLocationExpose = isLocationExpose
  }
}
