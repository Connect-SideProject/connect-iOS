//
//  SearchViewReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/11/22.
//

import ReactorKit

enum SearchViewTransform: TransformType {
    enum Event {
        case refreshKeywordSection
        case didTapRecentlyKeyword(keyword: String)
    }
    case none
}



public final class SearchViewReactor: Reactor {

    public enum Action {
        case viewDidLoad
        case updateKeyword(String?)
    }
    
    public enum Mutation {
        case setKeyword(String?)
        case setLoading(Bool)
        case setSearchKeywordItem
    }
    
    public struct State {
        var keyword: String?
        var isLoading: Bool
        @Pulse var section: [SearchSection]
    }
    
    public var initialState: State
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
        self.initialState = State(
            keyword: "",
            isLoading: false,
            section: [
                self.searchRepository.responseSearchKeywordsSectionItem()
            ]
        )
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(startLoading,endLoading)
        case let .updateKeyword(keyword):
            guard let keyword = keyword,
                  keyword.count > 1 else {
                return .concat(
                  .just(.setKeyword(nil)),
                  .just(.setSearchKeywordItem)
                )
            }
            return .empty()
        }
        
    }
    
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromRefreshSectionMutaion = SearchViewTransform.event.flatMap { [weak self] event in
            self?.updateRecentlyKeyword(from: event) ?? .empty()
        }
        return fromRefreshSectionMutaion
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            
        case .setSearchKeywordItem:
            let searchIndex = self.getIndex(section: .search([]))
            newState.section[searchIndex] = searchRepository.responseSearchKeywordsSectionItem()
            
        case let .setKeyword(keyword):
            newState.keyword = keyword
            
        }
        
        return newState
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


private extension SearchViewReactor {
    func updateRecentlyKeyword(from event: SearchViewTransform.Event) -> Observable<Mutation> {
        switch event {
        case .refreshKeywordSection:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let refreshSection = Observable<Mutation>.just(.setSearchKeywordItem)
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(
                startLoading,
                refreshSection,
                endLoading
            )
        case let .didTapRecentlyKeyword(keyword):
            
            return .just(.setKeyword(keyword))
        }
    }
    
    
}
