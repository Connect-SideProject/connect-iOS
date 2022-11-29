//
//  PostDIContainer.swift
//  App
//
//  Created by Kim dohyun on 2022/11/13.
//

import Foundation
import ReactorKit


import COCommon
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
        return PostListReactor()
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
    
    
    
}



final class PostListRepo: PostListRepository {
    
    private let postApiService: ApiService
    
    
    init(postApiService: ApiService = ApiManager.shared) {
        self.postApiService = postApiService
    }
    
    
    
    
}
