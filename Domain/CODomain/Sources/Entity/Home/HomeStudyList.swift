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
    public var parts: [HomeStudyPartList]
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case studyNewsIsEnd = "isEnd"
        case studyNewsTitle = "studyTitle"
        case studyNewsBookMark = "bookmark"
        case studyNewsMyBookMark = "myBookmark"
        case studyNewsInfo = "studyInfo"
        case parts
        
    }
    
}


public struct HomeStudyPartList: Codable {
    var studyRole: String
    var studyRoleCount: Int
    
    enum CodingKeys: String, CodingKey {
        case studyRole = "role"
        case studyRoleCount = "count"
    }
}


