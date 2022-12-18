//
//  PostAllList.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/12/05.
//

import Foundation


public struct PostAllList: Codable {
    public var postList: [PostContentList]
    public var postPage: PostContentPageList
    public var postTotalPage: Int
    public var postTotalElements: Int
    public var postisLastPage: Bool
    public var postPageSize: Int
    public var postPageNumber: Int
    public var postSort: PostContentPageSort
    public var postNumberOfElements: Int
    public var postisFirst: Bool
    public var postisEmpty: Bool
    
    enum CodingKeys: String, CodingKey {
        case postList = "content"
        case postPage = "pageable"
        case postTotalPage = "totalPages"
        case postTotalElements = "totalElements"
        case postisLastPage = "last"
        case postPageSize = "size"
        case postPageNumber = "number"
        case postSort = "sort"
        case postNumberOfElements = "numberOfElements"
        case postisFirst = "first"
        case postisEmpty = "empty"
        
        
    }
    
    
}


public struct PostContentList: Codable, Identifiable {
    public var id: Int
    public var contentisEnd: Bool
    public var contentStudyTitle: String
    public var contentBookMarkCount: Int
    public var contentisBookMark: Bool
    public var contentStudyType: String
    public var contentStudyInfo: String
    public var contentStudycreatAt: String
    public var contentStudyParts: [PostContentPartList]
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case contentisEnd = "isEnd"
        case contentStudyTitle = "studyTitle"
        case contentBookMarkCount = "bookmark"
        case contentisBookMark = "myBookmark"
        case contentStudyType = "studyType"
        case contentStudyInfo = "studyInfo"
        case contentStudycreatAt = "creatDt"
        case contentStudyParts = "parts"
    }
}


public struct PostContentPartList: Codable {
    
    public var contentStudyRole: String
    public var contentStudyPartCount: Int
    
    enum CodingKeys: String, CodingKey {
        
        case contentStudyRole = "role"
        case contentStudyPartCount = "count"
        
    }
    
}


public struct PostContentPageList: Codable {
    public var contentPageSort: PostContentPageSort
    public var contentPageoffset: Int
    public var contentPageSize: Int
    public var contentPageNumber: Int
    public var contentisPage: Bool
    public var contentisNotPage: Bool
    
    enum CodingKeys: String, CodingKey {
        case contentPageSort = "sort"
        case contentPageoffset = "offset"
        case contentPageSize = "pageSize"
        case contentPageNumber = "pageNumber"
        case contentisPage = "paged"
        case contentisNotPage = "unpaged"
    }
    
    
}


public struct PostContentPageSort: Codable {
    public var contentPageEmpty: Bool
    public var contentPageisNotSort: Bool
    public var contentPageisSort: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case contentPageEmpty = "empty"
        case contentPageisNotSort = "unsorted"
        case contentPageisSort = "sorted"
        
    }
    
}
