//
//  NoticeDependencyContainer.swift
//  App
//
//  Created by Kim dohyun on 2022/12/04.
//

import Foundation
import COCommon
import CONetwork



public final class NoticeDependencyContainer: HomeDIContainer {

    public typealias HomeReactor = NoticeViewReactor
    public typealias HomeViewRepository = NoticeRepositry
    public typealias HomeViewController = NoticeController
    
    private let noticeApiService: ApiService
    
    init(noticeApiService: ApiService) {
        self.noticeApiService = noticeApiService
    }
    
    public func makeReactor() -> NoticeViewReactor {
        return NoticeViewReactor()
    }
    
    public func makeRepository() -> HomeViewRepository {
        return NoticeViewRepo(noticeApiService: self.noticeApiService)
    }
    
    public func makeController() -> NoticeController {
        return NoticeController(reactor: makeReactor())
    }
    
    
}



//MARK: Repository
public protocol NoticeRepositry {
    
}


final class NoticeViewRepo: NoticeRepositry {
    
    
    private let noticeApiService: ApiService
    
    
    public init(noticeApiService: ApiService) {
        self.noticeApiService = noticeApiService
    }
    
    
    
    
}
