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


public enum ProfilePostType: String, Equatable {
    case bookMark
    case study
}



public final class ProfileMyPostReactor: Reactor {
    
    //MARK: Property
    private var profilePostType: ProfilePostType?
    private var profileMyPostRepository: ProfileMyPostRepository
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setMyStudyItem([ProfileStudy])
        case setMyBookMarkItem([ProfileBookMark])
    }
    
    public struct State {
        var isLoading: Bool
        var section: [ProfileMyPostSection]
    }
    
    public let initialState: State
    
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
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            if profilePostType == .bookMark {
                return .concat(
                    startLoading,
                    profileMyPostRepository.responseMyPostBookMarkItem(),
                    endLoading
                )
            } else {
                return .concat(
                    startLoading,
                    profileMyPostRepository.responseMyPostStudyItem(),
                    endLoading)
            }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            
            return newState
        case let .setMyStudyItem(items):
            var newState = state
            let myStudySectionIndex = self.getIndex(section: .myProfilePost([]))
            newState.section[myStudySectionIndex] = profileMyPostRepository.responseMyPostSectionItem(item: items)
            
            return newState

        case let .setMyBookMarkItem(items):
            var newState = state
            
            return newState
        }
    }
    
    
}


private extension ProfileMyPostReactor {
    
    func getIndex(section: ProfileMyPostSection) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.section.count {
            if self.currentState.section[i].getSectionType() == section.getSectionType() {
                index = i
            }
        }
        return index
    }
}
