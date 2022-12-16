//
//  HomeReleaseCellReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/10/29.
//

import ReactorKit
import CODomain



public final class HomeReleaseCellReactor: Reactor {
    
    
    public enum Action {
        case didTapBookMarkButton
    }
    
    public enum Mutation {
        case updateSelected(HomeBookMarkList)
    }
    
    
    public struct State {
        var releaseModel: HomeHotList
        var bookMarkModel: HomeBookMarkList?
    }
    
    public let initialState: State
    private let homeReleaseRepo: HomeViewRepo
    
    init(releaseModel: HomeHotList, homeReleaseRepo: HomeViewRepo) {
        self.initialState = State(releaseModel: releaseModel, bookMarkModel: nil)
        self.homeReleaseRepo = homeReleaseRepo

    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBookMarkButton:

            let bookMarkMutation = homeReleaseRepo.requestHomeBookMarkItem(id: String(self.currentState.releaseModel.id))
            
            
            return bookMarkMutation
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateSelected(items):
            newState.bookMarkModel = items
        }
        
        return newState
    }
    
    
}


