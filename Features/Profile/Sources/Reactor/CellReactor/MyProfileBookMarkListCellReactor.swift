//
//  MyProfileBookMarkListCellReactor.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/13.
//

import Foundation
import ReactorKit

import CODomain



final class MyProfileBookMarkListCellReactor: Reactor {
    
    
    enum Action {
        case didTapMyProfileBookMarkButton
    }
    
    enum Mutation {
        case updateMyPostBookMark(HomeBookMarkList)
    }
    
    struct State {
        var myBookMarkListModel: ProfileBookMark
        var myBookMarkModel: HomeBookMarkList?
    }
    
    let initialState: State
    private let profileRepo: ProfileMyPostRepository
    
    init(myBookMarkListModel: ProfileBookMark, profileRepo: ProfileMyPostRepository) {
        self.initialState = State(myBookMarkListModel: myBookMarkListModel, myBookMarkModel: nil)
        self.profileRepo = profileRepo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapMyProfileBookMarkButton:
            let myProfileBookMarkMutation = profileRepo.requestMyBookMarkItem(id: String(self.currentState.myBookMarkListModel.myBookMarkid))
            
            return myProfileBookMarkMutation
        }
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateMyPostBookMark(items):
            newState.myBookMarkModel = items
        }
        return newState
    }
    
}
