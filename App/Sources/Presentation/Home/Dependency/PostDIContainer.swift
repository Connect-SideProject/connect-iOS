//
//  PostDIContainer.swift
//  App
//
//  Created by Kim dohyun on 2022/11/13.
//

import Foundation
import ReactorKit


import COCommon
import CODomain
import CONetwork
import COManager


//MARK: Dependency
public final class PostDependencyContainer: HomeDIContainer {

    public typealias HomeReactor = PostListViewReactor
    public typealias HomeViewRepository = PostListRepository
    public typealias HomeViewController = PostListController
    
    private let postApiService: ApiService
    
    init(postApiService: ApiService) {
        self.postApiService = postApiService
    }
    
    
    public func makeReactor() -> PostListViewReactor {
        return PostListViewReactor(postRepository: makeRepository())
    }
    
    public func makeRepository() -> PostListRepository {
        return PostListRepo(postApiService: postApiService)
    }
    
    public func makeController() -> PostListController {
        return PostListController(reactor: makeReactor())
    }
    
    
}


public enum MeetingType: String, Equatable {
    
    case online = "온라인"
    case offline = "오프라인"
    case none = "미정"
    
    static func getMeetingType(_ type: String?) -> String {
        switch type {
        case "온라인":
            return MeetingType.online.rawValue
        case "오프라인":
            return MeetingType.offline.rawValue
        default:
            return MeetingType.none.rawValue
        }
    }
    
}


public enum StudyType: String, Equatable {
    
    case study = "스터디"
    case project = "프로젝트"
    case none = ""
    
    static func getStudyType(_ type: String?) -> String {
        switch type {
        case "스터디":
            return StudyType.study.rawValue
        case "프로젝트":
            return StudyType.project.rawValue
        default:
            return StudyType.none.rawValue
        }
    }
}

public enum AligmentType: String, Equatable {
    
    case fame = "인기순"
    case distance = "거리순"
    case none = ""
    
    static func getAligmentType(_ type: String?) -> String {
        switch type {
        case "인기순":
            return AligmentType.fame.rawValue
        case "거리순":
            return AligmentType.distance.rawValue
        default:
            return AligmentType.none.rawValue
        }
    }
}



//MARK: Repository
public protocol PostListRepository {
    func responsePostSheetItem() -> Observable<PostListViewReactor.Mutation>
    func responsePostListSectionItem(item: [PostContentList]) -> PostViewSection
    func responsePostListItem(parameter: [String: String]?) -> Observable<PostListViewReactor.Mutation>
    func requestPostBookMarkItem(id: String) -> Observable<PostListCellReactor.Mutation>
    
}



final class PostListRepo: PostListRepository {
    
    private let postApiService: ApiService
    private let postInterestService: InterestService
    
    init(
        postApiService: ApiService = ApiManager.shared,
        postInterestService: InterestService = InterestManager.shared
    ) {
        self.postApiService = postApiService
        self.postInterestService = postInterestService
    }
    
    
    func responsePostSheetItem() -> Observable<PostListViewReactor.Mutation> {
        
        return .just(.setPostSheetItem(postInterestService.interestList.map { $0.name }))
    }
    
    func responsePostListSectionItem(item: [CODomain.PostContentList]) -> PostViewSection {
        var postAllSectionItem: [PostSectionItem] = []
        
        for i in 0 ..< item.count {
            postAllSectionItem.append(.postList(PostListCellReactor(postModel: item[i], postListRepo: self)))
        }
        
        return PostViewSection.post(postAllSectionItem)
    }
    
    
    func responsePostListItem(parameter: [String: String]?) -> Observable<PostListViewReactor.Mutation> {
        let createPostItemResponse = postApiService.request(endPoint: .init(path: .search(parameter))).flatMap { (data: PostAllList) -> Observable<PostListViewReactor.Mutation> in
            
            return .just(.setPostListItem(data))
        }
        
        return createPostItemResponse
    }
    
    
    func requestPostBookMarkItem(id: String) -> Observable<PostListCellReactor.Mutation> {
        
        let createPostBookMarkResponse = postApiService.request(endPoint: .init(path: .homeBookMark(id))).flatMap { (data: HomeBookMarkList) -> Observable<PostListCellReactor.Mutation> in
            
            return .just(.setPostBookMarkItems(data))
        }
        
        return createPostBookMarkResponse
    }
    
    
    
}
