//
//  HomeBookMarkList.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/12/02.
//

import Foundation


public struct HomeBookMarkList: Codable {
    public var bookMarkId: Int
    public var bookMarkCount: Int
    public var bookMarkisCheck: Bool
    
    enum CodingKeys: String, CodingKey {
        case bookMarkId = "id"
        case bookMarkCount = "bookmarkCount"
        case bookMarkisCheck = "myBookmark"
    }

}
