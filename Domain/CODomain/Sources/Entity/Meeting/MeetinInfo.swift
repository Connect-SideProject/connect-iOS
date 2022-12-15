//
//  MeetingInfo.swift
//  CODomain
//
//  Created by Taeyoung Son on 2022/12/07.
//

import Foundation

// MARK: - MeetingInfo
public struct MeetingInfo: Codable {
    public var id: Int
    public var userID, nickName: String
    public var profileURL: String
    public var roles: [MeeingInfoRole]
    public var endDate, studyType, meetingType: String
    public var categories: [Category]
    public var parts: [Part]
    public var studyInfo, aspiration: String
    public var bookmark: Int
    public var place: Place
    public var end: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case nickName
        case profileURL = "profileUrl"
        case roles, endDate, studyType, meetingType, categories, parts, studyInfo, aspiration, bookmark, place, end
    }
}

// MARK: - Category
public struct Category: Codable {
    public var category: String
}

// MARK: - Place
public struct Place: Codable {
    public var name: String
    public var location: Location
}

// MARK: - Location
public struct Location: Codable {
    public var x, y: Double
}

// MARK: - MeeingInfoRole
public struct MeeingInfoRole: Codable {
    public var role: RoleType
}

// MARK: - Part
public struct Part: Codable {
    public var count: Int
    public var role: RoleType
    
    public var description: String {
        return self.role.description + " \(count) 명"
    }
}
