//
//  MyProfilePostListCellReactor.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/12.
//

import Foundation

import ReactorKit
import CODomain


final class MyProfilePostListCellReactor: Reactor {
    
    enum Action {
        case didTapStudyBookMarkButton
    }
    
    enum Mutation {
        case updateMyStudyBookMark(HomeBookMarkList)
    }
    
    struct State {
        var myStudyModel: ProfileStudy
        var myStudyBookMarkList: HomeBookMarkList?
    }
    
    let initialState: State
    private let profileStudyRepo: ProfileMyPostRepository
    
    init(myStudyModel: ProfileStudy, profileStudyRepo: ProfileMyPostRepository) {
        self.initialState = State(myStudyModel: myStudyModel, myStudyBookMarkList: nil)
        self.profileStudyRepo = profileStudyRepo
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapStudyBookMarkButton:
            let myProfileStudyBookMarkMutation = profileStudyRepo.requestMyStudyBookMarkItem(id: String(self.currentState.myStudyModel.myStudyid))
            
            return myProfileStudyBookMarkMutation
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateMyStudyBookMark(items):
            newState.myStudyBookMarkList = items
            
        }
    
        return newState
    }
}
