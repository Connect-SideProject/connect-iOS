//
//  PostDIContainer.swift
//  App
//
//  Created by Kim dohyun on 2022/11/13.
//

import Foundation
import COCommon
import CONetwork


//MARK: Dependency
final class PostDependencyContainer: HomeDIContainer {

    typealias HomeReactor = PostListReactor
    typealias HomeViewRepository = PostListRepository
    typealias HomeViewController = PostListController
    
    private let postApiService: ApiService
    
    init(postApiService: ApiService) {
        self.postApiService = postApiService
    }
    
    
    func makeReactor() -> PostListReactor {
        return PostListReactor()
    }
    
    func makeRepository() -> PostListRepository {
        return PostListRepo(postApiService: postApiService)
    }
    
    func makeController() -> PostListController {
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
