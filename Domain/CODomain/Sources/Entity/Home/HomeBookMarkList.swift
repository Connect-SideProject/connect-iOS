//
//  HomeBookMarkList.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/12/02.
//

import Foundation


public struct HomeBookMarkList: Codable {
    public var result: String
    public var data: Int
    public var message: String?
    public var errorCode: String?
    
    enum CodingKeys: String, CodingKey {
        case result, message
        case data
        case errorCode = "error_code"
    }
    
}
