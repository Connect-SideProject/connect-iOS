//
//  ProfileMyPostReactor.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/12.
//

import ReactorKit
import RxCocoa

import CODomain
import CONetwork


enum ProfilePostType: String, Equatable {
    case bookMark
    case study
}



final class ProfileMyPostReactor: Reactor {
    
    //MARK: Property
    private var profilePostType: ProfilePostType?
    private var profileMyPostRepository: ProfileMyPostRepository
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setMyStudyItem(ProfileStudy)
        case setMyBookMarkItem(ProfileBookMark)
    }
    
    struct State {
        var isLoading: Bool
        var section: [ProfileMyPostSection]
    }
    
    let initialState: State
    
    init(profilePostType: ProfilePostType, profileMyPostRepository: ProfileMyPostRepository) {
        defer { _ = self.state }
        
        self.profilePostType = profilePostType
        self.profileMyPostRepository = profileMyPostRepository
        self.initialState = State(
            isLoading: false,
            section: [
                .myProfilePost([])
            ]
        )
        
        
        
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            if profilePostType == .bookMark {
                return .concat(startLoading, endLoading)
            } else {
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            
            return newState
        case let .setMyStudyItem(items):
            var newState = state
            
            return newState

        case let .setMyBookMarkItem(items):
            var newState = state
            
            return newState
        }
    }
    
    
}
