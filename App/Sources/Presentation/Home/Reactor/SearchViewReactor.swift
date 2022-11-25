//
//  SearchViewReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/11/22.
//

import ReactorKit



public final class SearchViewReactor: Reactor {

    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setSearchKeywordItem([String])
    }
    
    public struct State {
        var isLoading: Bool
        var section: [SearchSection]
    }
    
    public var initialState: State
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        defer { _ = self.state }
        self.searchRepository = searchRepository
        self.initialState = State(
            isLoading: false,
            section: [
                .search([])
            ]
        )
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(startLoading,endLoading)
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            
            return newState
            
        case let .setSearchKeywordItem(items):
            var newState = state
            let searchIndex = self.getIndex(section: .search([]))
            newState.section[searchIndex] = searchRepository.responseSearchKeywordsSectionItem(item: items)
            return newState
        }
    }
    
    
}


private extension SearchViewReactor {
    func getIndex(section: SearchSection) -> Int {
        var index: Int = 0

        for i in 0 ..< self.currentState.section.count {
            if self.currentState.section[i].getSectionType() == section.getSectionType() {
                index = i
            }
        }
        return index
    }
}
