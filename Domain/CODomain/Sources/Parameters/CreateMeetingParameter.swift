//
//  CreateMeetingParameter.swift
//  CODomain
//
//  Created by sean on 2022/12/04.
//

import Foundation

public enum StudyType: String, Codable {
  case project, study
  
  public init?(rawValue: String) {
    switch rawValue {
    case "PROJECT":
      self = .project
    case "STUDY":
      self = .study
    default:
      return nil
    }
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer().decode(String.self)
    
    switch container {
    case "PROJECT":
      self = .project
    case "STUDY":
      self = .study
    default:
      fatalError("")
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .project:
      try container.encode("PROJECT")
    case .study:
      try container.encode("STUDY")
    }
  }
}

public enum MeetingType: Codable {
  case online, offline, none
  
  public init?(rawValue: String) {
    switch rawValue {
    case "ONLINE":
      self = .online
    case "OFFLINE":
      self = .offline
    default:
      self = .none
    }
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer().decode(String.self)
    
    switch container {
    case "ONLINE":
      self = .online
    case "OFFLINE":
      self = .offline
    default:
      self = .none
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .online:
      try container.encode("ONLINE")
    case .offline:
      try container.encode("OFFLINE")
    default:
      try container.encode("NONE")
    }
  }
}

public struct CreateMeetingParameter: Parameterable {
  
  let studyType: StudyType?
  let meetingType: MeetingType
  public var interestings: [Interest] = []
  public var roleAndCounts: [RoleAndCountItem] = []
  public var startDate: String?
  public var endDate: String?
  public var place: String?
  let title: String
  let content: String
  let aspiration: String
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(studyType, forKey: .studyType)
    try container.encode(meetingType, forKey: .meetingType)
    try container.encode(interestings, forKey: .interestings)
    try container.encode(roleAndCounts, forKey: .roleAndCounts)
    try container.encode(startDate, forKey: .startDate)
    try container.encode(endDate, forKey: .endDate)
    try container.encode(place, forKey: .place)
    try container.encode(title, forKey: .title)
    try container.encode(content, forKey: .content)
    try container.encode(aspiration, forKey: .aspiration)
  }
  
  enum CodingKeys: String, CodingKey {
    case studyType
    case meetingType
    case interestings = "categories"
    case roleAndCounts = "parts"
    case startDate
    case endDate
    case place
    case title = "studyTitle"
    case content = "studyInfo"
    case aspiration
  }
}

public extension CreateMeetingParameter {
  init(
    studyType: StudyType?,
    meetingType: MeetingType,
    title: String = "",
    content: String = "",
    aspiration: String = ""
  ) {
    self.studyType = studyType
    self.meetingType = meetingType
    self.title = title
    self.content = content
    self.aspiration = aspiration
  }
  
  mutating func updateInterestings(_ interestings: [Interest]) {
    self.interestings = interestings
  }
  
  mutating func updatePlace(_ place: String) {
    self.place = place
  }
  
  mutating func updateRoleAndCounts(_ roleAndCounts: [RoleAndCountItem]) {
    self.roleAndCounts = roleAndCounts
  }
  
  mutating func updateDateRange(
    startDate: String,
    endDate: String
  ) {
    self.startDate = startDate
    self.endDate = endDate
  }
}
