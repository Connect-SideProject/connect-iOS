//
//  HomeHotList.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/10/25.
//

import Foundation

public struct HomeHotList: Codable {
    
    public var releaseStudyType: String
    public var releaseTitle: String
    public var releaseBookMark: Int
    public var releaseStudyInfo: String
    public var releaseRecruitPart: [String]
    public var releaseCreateAt: String
    public var releaseisEnd: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case releaseStudyType = "studyType"
        case releaseTitle = "studyTitle"
        case releaseBookMark = "bookmark"
        case releaseStudyInfo = "studyInfo"
        case releaseRecruitPart = "recruitmentParts"
        case releaseCreateAt = "creatDt"
        case releaseisEnd = "isEnd"
        
    }
    
}
