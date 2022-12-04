//
//  CreateMeetingParameter.swift
//  CODomain
//
//  Created by sean on 2022/12/04.
//

import Foundation

public enum StudyType: Codable {
  case project, study
  
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
      try container.encode("PROJECT")
    case .offline:
      try container.encode("STUDY")
    default:
      try container.encode("NONE")
    }
  }
  
}

public struct RoleAndPeople: Codable {
  let role: String
  let count: Int
}

public struct CreateMeetingParameter: Parameterable {
  
  let studyType: StudyType
  let meetingType: MeetingType
  let interestings: [Interest]
  let roleAndPeople: RoleAndPeople
  let startDate: String
  let endDate: String
  let region: String
  let title: String
  let content: String
  let aspiration: String
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(studyType, forKey: .studyType)
    try container.encode(meetingType, forKey: .meetingType)
    try container.encode(interestings, forKey: .interestings)
    try container.encode(roleAndPeople, forKey: .roleAndPeople)
    try container.encode(startDate, forKey: .startDate)
    try container.encode(endDate, forKey: .endDate)
    try container.encode(region, forKey: .region)
    try container.encode(title, forKey: .title)
    try container.encode(content, forKey: .content)
    try container.encode(aspiration, forKey: .aspiration)
  }
  
  enum CodingKeys: String, CodingKey {
    case studyType
    case meetingType
    case interestings = "categories"
    case roleAndPeople = "parts"
    case startDate
    case endDate
    case region = "place"
    case title = "studyTitle"
    case content = "studyInfo"
    case aspiration
  }
}
