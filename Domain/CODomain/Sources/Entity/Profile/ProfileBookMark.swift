//
//  ProfileBookMark.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/12/12.
//

import Foundation

public enum ProfilePartsType: String {
    case develop = "개발자"
    case designer = "디자이너"
    case planner = "기획자"
    case marketer = "마케터"
}

public struct ProfileBookMark: Codable {
    
    public var myBookMarkid: Int
    public var myBookMarkisEnd: Bool
    public var myBookMarkTitle: String
    public var myBookMarkDescription: Int
    public var myBookMarkisCheck: Bool
    public var myBookMarkInfo: String
    public var myBookMarkParts: [ProfileBookMarkPart]
    
    enum CodingKeys: String, CodingKey {
        case myBookMarkid = "id"
        case myBookMarkisEnd = "isEnd"
        case myBookMarkTitle = "studyTitle"
        case myBookMarkDescription = "bookmark"
        case myBookMarkisCheck = "myBookmark"
        case myBookMarkInfo = "studyInfo"
        case myBookMarkParts = "parts"
        
    }
    
    public func setProfileResultsParts() -> String {
        return self.myBookMarkParts.map { $0.setProfileParts() }.joined(separator: " | ")
    }
    
}


public struct ProfileBookMarkPart: Codable {
    public var myBookMarkRole: String
    public var myBookMarkCount: Int
    
    
    enum CodingKeys: String, CodingKey {
        case myBookMarkRole = "role"
        case myBookMarkCount = "count"
    }
    
    public func setProfileParts() -> String {
        switch self.myBookMarkRole {
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
