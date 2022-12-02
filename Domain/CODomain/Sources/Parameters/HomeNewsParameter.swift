//
//  HomeNewsParameter.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/12/02.
//

import Foundation


public struct HomeNewsParameter: Parameterable {
    
    var area: String
    var studyType: String?
    
    enum CodingKeys: String, CodingKey {
        case area = "area2"
        case studyType
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(area, forKey: .area)
        try container.encode(studyType, forKey: .studyType)
    }
    
    public init(area: String, studyType: String? = nil) {
        self.area = area
        self.studyType = studyType
    }
    
    
}
