//
//  PostListViewReactor.swift
//  App
//
//  Created by Kim dohyun on 2022/11/13.
//

import ReactorKit
import RxCocoa

import COExtensions
import CONetwork
import COCommonUI
import CODomain


public enum PostFilterTransform: TransformType, Equatable {
    enum Event {
        case didTapOnOffLineSheet(text: String)
        case didTapAligmentSheet(text: String)
        case didTapStudyTypeSheet(text: String)
        case didTapInterestSheet(text: String)
        case responseSheetItem(item: [BottomSheetItem])
    }

    case none
}

public final class PostListViewReactor: Reactor, ErrorHandlerable {
    
    public enum Action {
        case viewDidLoad
        case didTapOnOffType(String)
        case didTapStudyType(String)
        case didTapInterestType(String)
    }
    
    public struct State {
        var isLoading: Bool
        var isError: COError?
        var bottomSheetItem: [BottomSheetItem]
        var section: [PostViewSection]
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPostError(COError?)
        case setPostSheetItem([String])
        case setPostListItem(PostAllList)
    }
    
    public var initialState: State
    private let postRepository: PostListRepository
    private var postParameter: [String: String] = [:]
    
    public var errorHandler: (Error) -> Observable<Mutation> = { error in
        return .just(.setPostError(error.asCOError))
    }
    
    init(postRepository: PostListRepository) {
        defer { _ = self.state }
        self.postRepository = postRepository
        self.initialState = State(
            isLoading: false,
            bottomSheetItem: [],
            section: [
                .post([])
            ]
        )
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            
            return .concat(
                startLoading,
                postRepository.responsePostSheetItem(),
                endLoading
            )
        case let .didTapOnOffType(meetingItem):
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            postParameter.updateValue(meetingItem, forKey: "meetingType")
            print("postParameter: \(postParameter)")
            return .concat(
                startLoading,
                postRepository.responsePostListItem(parameter: postParameter),
                endLoading
            )
        case let .didTapStudyType(studyItem):
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            postParameter.updateValue(studyItem, forKey: "studyType")
            print("postParameter: \(postParameter)")
            if studyItem == "전체" {
                return .concat(
                    startLoading,
                    postRepository.responsePostListItem(parameter: nil),
                    endLoading
                )
            } else {
                return .concat(
                    startLoading,
                    postRepository.responsePostListItem(parameter: postParameter),
                    endLoading
                )
            }
        case let .didTapInterestType(interestItem):
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            postParameter.updateValue(interestItem, forKey: "category")
            
            return .concat(
                startLoading,
                postRepository.responsePostListItem(parameter: postParameter),
                endLoading
            )
        }
    }
    
    public func transform(action: Observable<Action>) -> Observable<Action> {
        let fromSheetAction = PostFilterTransform.event.flatMap { [weak self] event in
            self?.didTapSheetAction(from: event) ?? .empty()
        }
        
        return Observable.of(action, fromSheetAction).merge()
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            
            return newState
            
        case let .setPostError(isError):
            var newState = state
            newState.isError = isError
            
            return newState
            
        case let .setPostSheetItem(items):
            var newState = state
            var bottomSheetItems: [BottomSheetItem] = []
            _ = items.map { item in
                bottomSheetItems.append(BottomSheetItem(value: item))
            }
            newState.bottomSheetItem = bottomSheetItems
            print("set Bottom Sheet Item: \(items)")
            return newState
        case let .setPostListItem(items):
            var newState = state
            let postAllIndex = self.getIndex(section: .post([]))
            print("Post All List Items: \(items)")
            newState.section[postAllIndex] = postRepository.responsePostListSectionItem(item: items.postList)
            return newState
        }
    }
    
}



private extension PostListViewReactor {
    func getIndex(section: PostViewSection) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.section.count {
            if self.currentState.section[i].getSectionType() == section.getSectionType() {
                index = i
            }
        }
        
        return index
    }
    
    
    func didTapSheetAction(from event: PostFilterTransform.Event) -> Observable<Action> {
        switch event {
        case let .didTapOnOffLineSheet(text):
            return .just(.didTapOnOffType(MeetingType.getMeetingType(text)))
        case let .didTapStudyTypeSheet(text):
            return .just(.didTapStudyType(StudyType.getStudyType(text)))
        case let .didTapInterestSheet(text):
            return .just(.didTapInterestType(text))
        default:
            return .empty()
        }
    }
    
}
