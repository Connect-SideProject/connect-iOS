//
//  HomeViewReactor.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import ReactorKit
import COExtensions
import CONetwork
import CODomain



final class HomeViewReactor: Reactor, ErrorHandlerable {
        
    let initialState: State
    
    enum Action {
        case viewDidLoad
    }
    
    public var errorHandler: (Error) -> Observable<Mutation> = { error in
        return .just(.setHomeError(error.asURLError))
    }
    
    private let homeApiService: ApiService
    
    
    enum Mutation {
        case setLoading(Bool)
        case setHomeMenuItem([HomeMenu])
        case setSubMenuItems(HomeViewSection)
        case setStudyListItems(HomeViewSection)
        case setHomeError(URLError?)
    }
    
    struct State {
        var isLoading: Bool
        var isError: URLError?
        var section: [HomeViewSection]
    }
    
    init(homeApiService: ApiService) {
        defer { _ = self.state }
        self.homeApiService = homeApiService
        self.initialState = State(
            isLoading: false,
            isError: nil,
            section: [
                .field([]),
                .homeSubMenu([]),
                .homeStudyList([])
            ]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let setMenuItems = Observable<Mutation>.just(.setSubMenuItems(.homeSubMenu([
                .homeStudyMenu(HomeStudyMenuReactor(menuType: .all)),
                .homeStudyMenu(HomeStudyMenuReactor(menuType: .project)),
                .homeStudyMenu(HomeStudyMenuReactor(menuType: .study))
            ])))
            
            
            let setStudyListItems = Observable<Mutation>.just(.setStudyListItems(.homeStudyList([
                .homeStudyList,
                .homeStudyList,
                .homeStudyList
            ])))
                        
            return .concat([
                startLoading,
                createHomeMenuSection(),
                setMenuItems,
                setStudyListItems,
                endLoading
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            
            return newState
            
        case let .setHomeMenuItem(items):
            var newState = state
            guard let sectionIndex = self.getIndex(section: .field([])) else { return newState }
            newState.section[sectionIndex] = homeMenuSectionItem(item: items)
            print("setHomeMenu Response Item: \(items)")
           
            return newState
        case let .setSubMenuItems(items):
            var newState = state
            guard let sectionIndex = self.getIndex(section: .homeSubMenu([])) else { return newState }
            newState.section[sectionIndex] = items
            return newState
            
        case let .setStudyListItems(items):
            var newState = state
            guard let sectionIndex = self.getIndex(section: .homeStudyList([])) else { return newState }
            newState.section[sectionIndex] = items
            
            return newState
            
        case let .setHomeError(error):
            var newState = state
            newState.isError = error?.asURLError
            
            return newState
        }
        
        
    }
}


private extension HomeViewReactor {
    func getIndex(section: HomeViewSection) -> Int? {
        var index: Int? = nil
        
        for i in 0 ..< self.currentState.section.count {
            if self.currentState.section[i].getSectionType() == section.getSectionType() {
                index = i
            }
        }
        return index
    }
    
    
    private func createHomeMenuSection() -> Observable<Mutation> {
        let createMenuResponse = homeApiService.request(endPoint: .init(path: .homeMenu))
            .flatMap { (data: [HomeMenu]) -> Observable<Mutation> in
                
                return .just(.setHomeMenuItem(data))
            }
        return createMenuResponse
    }
    
    private func homeMenuSectionItem(item: [HomeMenu]) -> HomeViewSection {
        var homeMenuSectionItem: [HomeViewSectionItem] = []
        for i in 0 ..< item.count {
            homeMenuSectionItem.append(.homeMenu(HomeMenuCellReactor(menuType: item[i])))
        }
        return HomeViewSection.field(homeMenuSectionItem)
    }
    
}

