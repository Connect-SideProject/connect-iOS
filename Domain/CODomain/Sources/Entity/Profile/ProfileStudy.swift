//
//  ProfileStudy.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/12/12.
//

import Foundation


public struct ProfileStudy: Codable {
    
    public var myStudyid: Int
    public var myStudyisEnd: Bool
    public var myStudyTitle: String
    public var myStudyBookMark: Int
    public var myStudyisBookMark: Bool
    public var myStudyInfo: String
    public var myStudyParts: [ProfileStudyPart]
    
    enum CodingKeys: String, CodingKey {
        case myStudyid = "id"
        case myStudyisEnd = "isEnd"
        case myStudyTitle = "studyTitle"
        case myStudyBookMark = "bookmark"
        case myStudyisBookMark = "myBookmark"
        case myStudyInfo = "studyInfo"
        case myStudyParts = "parts"
    }
    
    public func setProfileStudyResultsParts() -> String {
        return self.myStudyParts.map { $0.setProfileStudyParts() }
            .joined(separator: " | ")
    }

}


public struct ProfileStudyPart: Codable {
    public var myStudyMemberRole: String
    public var myStudyMemberCount: Int
    
    enum CodingKeys: String, CodingKey {
        case myStudyMemberRole = "role"
        case myStudyMemberCount = "count"
    }
    
    public func setProfileStudyParts() -> String {
        switch self.myStudyMemberRole {
        case "DEV":
            return ProfilePartsType.develop.rawValue
        case "DESIGN":
            return ProfilePartsType.designer.rawValue
        case "PM":
            return ProfilePartsType.planner.rawValue
        case "MAK":
            return ProfilePartsType.marketer.rawValue
        default:
            return ""
        }
        
    }
}
