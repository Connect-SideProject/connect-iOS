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
        case didTapBookMarkButton(String)
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
        defer { _ = self.state }
        self.initialState = State(releaseModel: releaseModel, bookMarkModel: nil)
        self.homeReleaseRepo = homeReleaseRepo
        print("Release Model : \(releaseModel)")
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didTapBookMarkButton(id):
            let bookMarkMutation = homeReleaseRepo.requestHomeBookMarkItem(id: id)
            
            return bookMarkMutation
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .updateSelected(items):
            var newState = state
            newState.bookMarkModel = items
      
            print("bookMark Model: \(items)")
            return newState
        }
    }
    
    
}


