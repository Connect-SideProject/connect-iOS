//
//  HomeMenu.swift
//  CODomain
//
//  Created by Kim dohyun on 2022/10/22.
//

import Foundation
import UIKit

public struct HomeMenu: Codable {
    public var menuTitle: String
    public var menuImage: String
    
    
    enum CodingKeys: String, CodingKey {
        case menuTitle = "imgTitle"
        case menuImage = "imgUrl"
    }
    
    public func getMenuImage() throws -> UIImage {
        guard let Imageurl = URL(string: menuImage),
              let imageData = try? Data(contentsOf: Imageurl) else { return UIImage() }
        return UIImage(data: imageData) ?? UIImage()
    }
    
    
    
}
