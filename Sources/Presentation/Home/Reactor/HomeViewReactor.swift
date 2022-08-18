//
//  HomeViewReactor.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import ReactorKit


struct MockStruct {
    var image: String
    var title: String
}

enum HomeSectionType: String, Equatable {
    case field
}


final class HomeViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case didScroll
        case didEndScroll
        case viewDidLoad
    }
    
    enum Mutation {
        case setDidScrollView(Bool)
        case setFieldItemList([MockStruct])
    }
    
    struct State {
        var isScroll: Bool
        var section: [HomeViewSection]
    }
    
    init() {
        defer { _ = self.state }
        self.initialState = State(
            isScroll: false,
            section: [
                .field([])
            ]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didScroll:
            let didScroll = Observable<Mutation>.just(.setDidScrollView(true))
            return didScroll
        case .didEndScroll:
            let didendScroll = Observable<Mutation>.just(.setDidScrollView(false))
            return didendScroll
        case .viewDidLoad:
            let setLoadCollectionView = Observable<Mutation>.just(.setFieldItemList([
                MockStruct(image: "", title: "커머스"),
                MockStruct(image: "", title: "금융"),
                MockStruct(image: "", title: "헬스케어"),
                MockStruct(image: "", title: "여행")
            ]))

            return setLoadCollectionView
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setDidScrollView(isState):
            var newState = state
            newState.isScroll = isState
            return newState
        case let .setFieldItemList(items):
            var newState = state
            guard let sectionIndex = self.getIndex(section: .field([])) else { return newState }
            
            newState.section[sectionIndex] = self.createFieldItem(items: items)
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
    
    
    func createFieldItem(items: [MockStruct]) -> HomeViewSection {
        guard items.count > 0 else { return .field([]) }
        
        let sectionItems = items.map { $0 }
        return .field([.field(sectionItems)])
    }
    
}
