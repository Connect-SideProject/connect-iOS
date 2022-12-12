//
//  ProfileBookMark.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/12/12.
//

import Foundation


public struct ProfileBookMark: Codable {
    
    public var myBookMarkid: Int
    public var myBookMarkisEnd: Bool
    public var myBookMarkTitle: String
    public var myBookMarkDescription: Int
    public var myBookMarkisCheck: Bool
    public var myBookMarkInfo: String
    public var myBookMarkParts: [ProfileStudyPart]
    
    enum CodingKeys: String, CodingKey {
        case myBookMarkid = "id"
        case myBookMarkisEnd = "isEnd"
        case myBookMarkTitle = "studyTitle"
        case myBookMarkDescription = "bookmark"
        case myBookMarkisCheck = "myBookmark"
        case myBookMarkInfo = "studyInfo"
        case myBookMarkParts = "parts"
        
    }
    
}


public struct ProfileBookMarkPart: Codable {
    public var myBookMarkRole: String
    public var myBookMarkCount: Int
    
    
    enum CodingKeys: String, CodingKey {
        case myBookMarkRole = "role"
        case myBookMarkCount = "count"
    }
}
