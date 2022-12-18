//
//  HomeStudyList.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/11/11.
//

import Foundation

public struct HomeStudyList: Codable {

    public var study: [HomeStudyNodeList]
    
}


public struct HomeStudyNodeList: Codable {
    
    public var studyNewsType: String
    public var studyNewsTitle: String
    public var studyNewsBookMark: String
    public var studyNewsInfo: String
    public var studyNewsMember: [String]
    public var studyNewsIsEnd: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case studyNewsType = "studyType"
        case studyNewsTitle = "studyTitle"
        case studyNewsBookMark = "bookmark"
        case studyNewsInfo = "studyInfo"
        case studyNewsMember = "studyMember"
        case studyNewsIsEnd = "isEnd"
        
    }
    
}
