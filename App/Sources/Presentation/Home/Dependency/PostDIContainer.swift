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

    public typealias HomeReactor = PostListReactor
    public typealias HomeViewRepository = PostListRepository
    public typealias HomeViewController = PostListController
    
    private let postApiService: ApiService
    
    init(postApiService: ApiService) {
        self.postApiService = postApiService
    }
    
    
    public func makeReactor() -> PostListReactor {
        return PostListReactor(postRepository: makeRepository())
    }
    
    public func makeRepository() -> PostListRepository {
        return PostListRepo(postApiService: postApiService)
    }
    
    public func makeController() -> PostListController {
        return PostListController(reactor: makeReactor())
    }
    
    
}


//MARK: Repository
public protocol PostListRepository {
    func responsePostSheetItem() -> Observable<PostListReactor.Mutation>
    
    
}



final class PostListRepo: PostListRepository {
    
    private let postApiService: ApiService
    
    
    init(postApiService: ApiService = ApiManager.shared) {
        self.postApiService = postApiService
    }
    
    
    func responsePostSheetItem() -> Observable<PostListReactor.Mutation> {
        let createSheetItemResponse = postApiService.request(endPoint: .init(path: .homeMenu)).flatMap { (data: [HomeMenuList]) -> Observable<PostListReactor.Mutation> in
            
            return .just(.setPostSheetItem(data.map {$0.menuTitle}))
        }
        
        return createSheetItemResponse
    }
    
    
    
    
}
