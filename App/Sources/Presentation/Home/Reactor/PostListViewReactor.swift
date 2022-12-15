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
        case searchToKeyword(keyword: String)
        case responseSheetItem(item: [BottomSheetItem])
    }

    case none
}

public final class PostListViewReactor: Reactor, ErrorHandlerable {
    
    public enum Action {
        case viewDidLoad
        case updateKeywordItem(String)
        case didTapOnOffType(String)
        case didTapStudyType(String)
        case didTapInterestType(String)
        case didTapAligmentType(String)
        case updatePageItem(Int, Bool)
    }
    
    public struct State {
        var isLoading: Bool
        var isPageLoading: Bool
        var isError: COError?
        var pages: Int
        @Pulse var bottomSheetItem: [BottomSheetItem]
        @Pulse var section: [PostViewSection]
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPageLoading(Bool)
        case setPostError(COError?)
        case setPostSheetItem([String])
        case setUpdatePage(Int)
        case setPostListItem(PostAllList)
    }
    
    public var initialState: State
    private let postRepository: PostListRepository
    private var postParameter: [String: String] = [:]
    
    public var errorHandler: (Error) -> Observable<Mutation> = { error in
        return .just(.setPostError(error.asCOError))
    }
    
    init(postRepository: PostListRepository) {
        self.postRepository = postRepository
        self.postParameter = [
            "size": "10"
        ]
        self.initialState = State(
            isLoading: false,
            isPageLoading: false,
            pages: 10,
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
            return .concat(
                startLoading,
                postRepository.responsePostListItem(parameter: postParameter),
                endLoading
            )
        case let .didTapStudyType(studyItem):
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            postParameter.updateValue(studyItem, forKey: "studyType")
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
            
        case let .didTapAligmentType(aligmentItem):
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            postParameter.updateValue(aligmentItem, forKey: "sort")
            
            return .concat(
                startLoading,
                postRepository.responsePostListItem(parameter: postParameter),
                endLoading
            )
            
        case let .updateKeywordItem(keyword):
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            postParameter.updateValue(keyword, forKey: "keyword")
            
            return .concat(
                startLoading,
                postRepository.responsePostListItem(parameter: postParameter),
                endLoading
            )
        case let .updatePageItem(pages, isPageLoad):
            let startLoading = Observable<Mutation>.just(.setPageLoading(isPageLoad))
            let endLoading = Observable<Mutation>.just(.setPageLoading(false))
            let updatePages = Observable<Mutation>.just(.setUpdatePage(pages))
            
            postParameter.updateValue(String(self.currentState.pages), forKey: "size")
            
            return .concat(
                startLoading,
                updatePages,
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
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .setPostError(isError):
            newState.isError = isError
                        
        case let .setPostSheetItem(items):
            var bottomSheetItems: [BottomSheetItem] = []
            _ = items.map { item in
                bottomSheetItems.append(BottomSheetItem(value: item))
            }
            newState.bottomSheetItem = bottomSheetItems
        case let .setPostListItem(items):
            let postAllIndex = self.getIndex(section: .post([]))
            newState.section[postAllIndex] = postRepository.responsePostListSectionItem(item: items.postList)
            
        case let .setUpdatePage(pages):
            newState.pages = self.currentState.pages + pages
            
        case let .setPageLoading(isPageLoading):
            newState.isPageLoading = isPageLoading
        }
        
        return newState
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
        case let .didTapAligmentSheet(text):
            return .just(.didTapAligmentType(AligmentType.getAligmentType(text)))
        case let .searchToKeyword(keyword):
            return .just(.updateKeywordItem(keyword))
        default:
            return .empty()
        }
    }
    
}
