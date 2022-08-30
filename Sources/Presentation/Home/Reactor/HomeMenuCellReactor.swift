//
//  HomeFilterReactor.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/25.
//  Copyright © 2022 sideproj. All rights reserved.
//


enum HomeMenuCategory {
    case commercemenu
    case financemenu
    case healthmenu
    case travelmenu
    
    func getTitle() -> String? {
        switch self {
        case .commercemenu: return "커머스"
        case .financemenu: return "금융"
        case .healthmenu: return "헬스케어"
        case .travelmenu: return "여행"
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .commercemenu: return UIImage(named: "home_menu_commerce")
        case .financemenu: return  UIImage(named: "home_menu_finance")
        case .healthmenu: return UIImage(named: "home_menu_health")
        case .travelmenu: return UIImage(named: "home_menu_travel")
        }
    }
}

import ReactorKit
import UIKit


final class HomeMenuCellReactor: Reactor {
    
    
    typealias Action = NoAction
    
    
    struct State {
        var menuType: HomeMenuCategory
    }
    
    let initialState: State
    
    init(menuType: HomeMenuCategory) {
        self.initialState = State(menuType: menuType)
        _ = self.state
    }
    
    
    
}
