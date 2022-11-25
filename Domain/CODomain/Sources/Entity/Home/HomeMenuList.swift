//
//  HomeMenu.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/10/22.
//

import Foundation
import UIKit

public struct HomeMenuList: Codable {
    public var menuTitle: String
    public var menuImage: String
    
    
    enum CodingKeys: String, CodingKey {
        case menuTitle = "imgTitle"
        case menuImage = "imgUrl"
    }
    
    
}
