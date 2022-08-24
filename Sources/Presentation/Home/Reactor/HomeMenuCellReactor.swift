//
//  HomeFilterReactor.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/25.
//  Copyright © 2022 sideproj. All rights reserved.
//


enum HomeMenuCategory {
    case commerce
    case finance
    case health
    case travel
    
    public func getTitle() -> String {
        switch self {
        case .commerce: return "커머스"
        case .finance: return "금융"
        case .health: return "헬스케어"
        case .travel: return "여행"
        }
    }
    
    public func getImage() -> UIImage? {
        switch self {
        case .commerce: return UIImage(named: "home_menu_commerce")
        case .finance: return  UIImage(named: "home_menu_finance")
        case .health: return UIImage(named: "home_menu_health")
        case .travel: return UIImage(named: "home_menu_travel")
        }
    }
}

import ReactorKit
import UIKit


final class HomeMenuCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case didSelectSearchView
    }
    
    enum Mutation {
        case willAppearSearchView(Void)
    }
    
    struct State {
        var menuType: HomeMenuCategory
    }
    
    
    init(menuType: HomeMenuCategory) {
        defer { _ = self.state }
        self.initialState = State(menuType: menuType)
    }
    
    
    
}
