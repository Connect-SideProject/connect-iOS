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
    private var profilePostType: ProfilePostType
    private var profileMyPostRepository: ProfileMyPostRepository
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setLoadType(ProfilePostType)
        case setmyStudyItem([ProfileStudy])
        case setmyPostEmpty(ProfileMyPostSection)
        case setmyBookMarkItem([ProfileBookMark])
    }
    
    public struct State {
        var isLoading: Bool
        var isError: COError?
        var isPostType: ProfilePostType
        @Pulse var section: [ProfileMyPostSection]
    }
    
    public var initialState: State
    
    public lazy var errorHandler: (Error) -> Observable<Mutation> = { error in
        if self.profilePostType == .bookMark {
            return .just(.setmyPostEmpty(.myProfileBookMark([])))
        } else {
            return .just(.setmyPostEmpty(.myProfilePost([])))
        }
    }
    
    init(profilePostType: ProfilePostType, profileMyPostRepository: ProfileMyPostRepository) {
        
        self.profilePostType = profilePostType
        self.profileMyPostRepository = profileMyPostRepository
        self.initialState = State(
            isLoading: false,
            isError: nil,
            isPostType: .study,
            section: []
        )
        
        if self.profilePostType == .bookMark {
            self.initialState.section = [
                .myProfileBookMark([])
            ]
        } else {
            self.initialState.section = [
                .myProfilePost([])
            ]
        }
        
        
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            if profilePostType == .bookMark {
                return .concat(
                    startLoading,
                    Observable<Mutation>.just(.setLoadType(self.profilePostType)),
                    profileMyPostRepository.responseMyPostBookMarkItem().catch(errorHandler),
                    endLoading
                )
            } else {
                return .concat(
                    startLoading,
                    Observable<Mutation>.just(.setLoadType(self.profilePostType)),
                    profileMyPostRepository.responseMyPostStudyItem().catch(errorHandler),
                    endLoading
                )
            }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading

        case let .setmyStudyItem(items):
            let myStudySectionIndex = self.getIndex(section: .myProfilePost([]))
            newState.section[myStudySectionIndex] = profileMyPostRepository.responseMyPostSectionItem(item: items)
            
        case let .setmyBookMarkItem(items):
            let myBookMarkSectionIndex = self.getIndex(section: .myProfileBookMark([]))
            newState.section[myBookMarkSectionIndex] = profileMyPostRepository.responseMyBookMarkSectionItem(item: items)
            
        case let .setLoadType(isPostType):
            newState.isPostType = isPostType

        case let .setmyPostEmpty(isEmpty):
            let myEmptyType = self.profilePostType == .bookMark ? self.getIndex(section: .myProfileBookMark([])) : self.getIndex(section: .myProfilePost([]))
            newState.section[myEmptyType] = isEmpty
            
        }
        return newState
    }
    
    
}


private extension ProfileMyPostReactor {
    
    func getIndex(section: ProfileMyPostSection) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.section.count where self.currentState.section[i].getSectionType() == section.getSectionType() {
            index = i
        }
        return index
    }
}
