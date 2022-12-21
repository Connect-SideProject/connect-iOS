//
//  PlaceStudyInfo.swift
//  App
//
//  Created by 이건준 on 2022/12/21.
//

import Foundation

struct PlaceStudyInfo: Codable {
    let id: Int
    let isEnd: Bool
    let studyTitle: String
    let bookmark: Int
    let myBookmark: Bool
    let studyInfo: String
    let parts: [Part]
    let userId: String
    let reportCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, isEnd, studyTitle, bookmark, myBookmark, studyInfo, parts, userId, reportCount
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.isEnd = try values.decodeIfPresent(Bool.self, forKey: .isEnd) ?? false
        self.studyTitle = try values.decodeIfPresent(String.self, forKey: .studyTitle) ?? ""
        self.bookmark = try values.decodeIfPresent(Int.self, forKey: .bookmark) ?? 0
        self.myBookmark = try values.decodeIfPresent(Bool.self, forKey: .myBookmark) ?? false
        self.studyInfo = try values.decodeIfPresent(String.self, forKey: .studyInfo) ?? ""
        self.parts = try values.decodeIfPresent([Part].self, forKey: .parts) ?? []
        self.userId = try values.decodeIfPresent(String.self, forKey: .userId) ?? ""
        self.reportCount = try values.decodeIfPresent(Int.self, forKey: .reportCount) ?? 0
    }
}

struct Part: Codable {
    let role: String
    let count: Int
}
