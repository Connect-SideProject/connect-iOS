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
    
    case online = "ONLINE"
    case offline = "OFFLINE"
    case none = ""
    
    func getMeetingType(_ type: String?) -> String {
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
    
    case study = "STUDY"
    case project = "PROJECT"
    case none = ""
    
    func getStudyType(_ type: String?) -> String {
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


//MARK: Repository
public protocol PostListRepository {
    func responsePostSheetItem() -> Observable<PostListViewReactor.Mutation>
    func responsePostListSectionItem(item: [PostContentList]) -> PostViewSection
    func responsePostListItem(parameter: [String: String]?) -> Observable<PostListViewReactor.Mutation>
    
}



final class PostListRepo: PostListRepository {
    
    private let postApiService: ApiService
    
    
    init(postApiService: ApiService = ApiManager.shared) {
        self.postApiService = postApiService
    }
    
    
    func responsePostSheetItem() -> Observable<PostListViewReactor.Mutation> {
        let createSheetItemResponse = postApiService.request(endPoint: .init(path: .homeMenu)).flatMap { (data: [HomeMenuList]) -> Observable<PostListViewReactor.Mutation> in
            
            return .just(.setPostSheetItem(data.map {$0.menuTitle}))
        }
        
        return createSheetItemResponse
    }
    
    func responsePostListSectionItem(item: [CODomain.PostContentList]) -> PostViewSection {
        var postAllSectionItem: [PostSectionItem] = []
        
        for i in 0 ..< item.count {
            postAllSectionItem.append(.postList(PostListCellReactor(postModel: item[i])))
        }
        
        return PostViewSection.post(postAllSectionItem)
    }
    
    
    func responsePostListItem(parameter: [String: String]?) -> Observable<PostListViewReactor.Mutation> {
        let createPostItemResponse = postApiService.request(endPoint: .init(path: .search(parameter))).flatMap { (data: PostAllList) -> Observable<PostListViewReactor.Mutation> in
            
            return .just(.setPostListItem(data))
        }
        
        return createPostItemResponse
    }
    
    
    
    
}
