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

}


public struct ProfileStudyPart: Codable {
    public var myStudyMemberRole: String
    public var myStudyMemberCount: Int
    
    enum CodingKeys: String, CodingKey {
        case myStudyMemberRole = "role"
        case myStudyMemberCount = "count"
    }
}
