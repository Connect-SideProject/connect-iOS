//
//  HomeStudyList.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/11/11.
//

import Foundation

public struct HomeStudyList: Codable {

    public var id: Int
    public var studyNewsIsEnd: Bool
    public var studyNewsTitle: String
    public var studyNewsBookMark: Int
    public var studyNewsMyBookMark: Bool
    public var studyNewsInfo: String
    public var studyNewsParts: [HomeStudyPartList]
    public var studyNewsUserId: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case studyNewsIsEnd = "isEnd"
        case studyNewsTitle = "studyTitle"
        case studyNewsBookMark = "bookmark"
        case studyNewsMyBookMark = "myBookmark"
        case studyNewsInfo = "studyInfo"
        case studyNewsParts = "parts"
        case studyNewsUserId = "userId"
        
    }
    
}


public struct HomeStudyPartList: Codable {
    public var studyRole: String
    public var studyRoleCount: Int
    
    enum CodingKeys: String, CodingKey {
        case studyRole = "role"
        case studyRoleCount = "count"
    }
}


