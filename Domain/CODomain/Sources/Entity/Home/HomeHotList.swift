//
//  HomeHotList.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/10/25.
//

import Foundation

public struct HomeHotList: Codable, Identifiable {
    public var id: Int
    public var releaseisEnd: Bool
    public var releaseTitle: String
    public var releaseBookMark: Int
    public var releaseMyBookMark: Bool
    public var releaseStudyInfo: String
    public var releaseRecruitPart: [HomePartsList]
    public var releaseUserId: String
    
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case releaseisEnd = "isEnd"
        case releaseTitle = "studyTitle"
        case releaseBookMark = "bookmark"
        case releaseMyBookMark = "myBookmark"
        case releaseStudyInfo = "studyInfo"
        case releaseRecruitPart = "parts"
        case releaseUserId = "userId"
    }
}


public struct HomePartsList: Codable {
    public var role: String
    public var partsCount: Int
    
    
    enum CodingKeys: String, CodingKey {
        case role
        case partsCount = "count"
    }
    
    
}
