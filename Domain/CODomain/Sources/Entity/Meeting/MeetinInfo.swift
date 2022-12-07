//
//  MeetingInfo.swift
//  CODomain
//
//  Created by Taeyoung Son on 2022/12/07.
//

import Foundation

// MARK: - MeetingInfo
public struct MeetingInfo: Codable {
    let id: Int
    let userID, nickName: String
    let profileURL: String
    let roles: [MeeingInfoRole]
    let endDate, studyType, meetingType: String
    let categories: [Category]
    let parts: [Part]
    let studyInfo, aspiration: String
    let bookmark: Int
    let place: Place
    let end: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case nickName
        case profileURL = "profileUrl"
        case roles, endDate, studyType, meetingType, categories, parts, studyInfo, aspiration, bookmark, place, end
    }
}

// MARK: - Category
struct Category: Codable {
    let category: String
}

// MARK: - Place
struct Place: Codable {
    let name: String
    let location: Location
}

// MARK: - Location
struct Location: Codable {
    let x, y: Double
}

// MARK: - MeeingInfoRole
struct MeeingInfoRole: Codable {
    let role: RoleType
}

// MARK: - Part
struct Part: Codable {
    let count: Int
    let role: RoleType
}
