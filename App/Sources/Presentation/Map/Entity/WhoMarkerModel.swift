//
//  StudyMarkerInfo.swift
//  App
//
//  Created by 이건준 on 2022/12/20.
//

import Foundation

struct WhoMarkerModel: Codable {
    let id: Int
    let title: String
    let count: Int
    let location: MapCoordinate?
    
    enum CodingKeys: String, CodingKey {
        case id, title, count, location
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.count = try values.decodeIfPresent(Int.self, forKey: .count) ?? 0
        self.location = try values.decodeIfPresent(MapCoordinate.self, forKey: .location) 
    }
}

