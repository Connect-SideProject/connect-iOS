//
//  HomeDIContainer.swift
//  App
//
//  Created by Kim dohyun on 2022/10/30.
//

import Foundation
import CODomain
import COCommon
import ReactorKit
import UIKit
import CONetwork

//MARK: Dependency
public final class HomeDependencyContainer: HomeDIContainer {
    public typealias HomeReactor = HomeViewReactor
    public typealias HomeViewRepository = HomeRepository
    public typealias HomeViewController = HomeController
    public typealias ChildrenDependency = PostDependencyContainer
    
    private let homeApiService: ApiService
    
    
    public init(homeApiService: ApiService) {
        self.homeApiService = homeApiService
    }
    
    deinit {
        print(#function)
    }
    
    
    public func makeReactor() -> HomeViewReactor {
        return HomeViewReactor(homeRepository: makeRepository())
    }
    
    public func makeRepository() -> HomeViewRepository {
        return HomeViewRepo(homeApiService: homeApiService)
    }
    
    public func makeController() -> HomeController {
        return HomeController(reactor: makeReactor())
    }
    
    

}


extension HomeDependencyContainer {
    
    public func makeChildrenDependency() -> PostDependencyContainer {
        return PostDependencyContainer(postApiService: self.homeApiService)
    }
    
    public func makeChildrenController() -> PostListController {
        return makeChildrenDependency().makeController()
    }
    
}



public protocol HomeRepository {
    func responseMenuImage(image: HomeMenuList) async throws -> Data
    func responseHomeReleaseItem() -> Observable<HomeViewReactor.Mutation>
    func responseHomeMenuItem() -> Observable<HomeViewReactor.Mutation>
    func responseHomeNewsItem(paramenter: [String: String?]) -> Observable<HomeViewReactor.Mutation>
    func responseHomeReleaseSectionItem(item: [HomeHotList]) -> HomeReleaseSection
    func responseHomeMenuSectionItem(item: [HomeMenuList]) -> HomeViewSection
    func responseHomeNewsSectionItem(item: [HomeStudyList]) -> HomeViewSection
    func requestHomeBookMarkItem(id: String) -> Observable<HomeReleaseCellReactor.Mutation>
    func requestHomeNewsBookMarkItem(id: String) -> Observable<HomeStudyListReactor.Mutation>
}


final class HomeViewRepo: HomeRepository {
    
    private let homeApiService: ApiService
    
    public init(homeApiService: ApiService = ApiManager.shared) {
        self.homeApiService = homeApiService
    }
    
    
    func responseMenuImage(image item: HomeMenuList) async throws -> Data {
        guard let imageurl = URL(string: item.menuImage),
              let (imageData, _) = try? await URLSession.shared.data(from: imageurl) else { return Data() }
        return UIImage(data: imageData)?.pngData() ?? Data()
    }
    
    
    func responseHomeMenuItem() -> Observable<HomeViewReactor.Mutation> {
        let creteMenuResponse = homeApiService.request(endPoint: .init(path: .homeMenu)).flatMap { (data: [HomeMenuList]) -> Observable<HomeViewReactor.Mutation> in
            
            return .just(.setHomeMenuItem(data))
        }
        
        return creteMenuResponse
    }
    
    func responseHomeNewsItem(paramenter: [String: String?]) -> Observable<HomeViewReactor.Mutation> {
        let createNewsResponse = homeApiService.request(endPoint: .init(path: .homeNews(paramenter))).flatMap { (data: [HomeStudyList]) -> Observable<HomeViewReactor.Mutation> in
            
            return .just(.setHomeNewsItem(data))
        }
        
        return createNewsResponse
    }
    
    
    func responseHomeReleaseItem() -> Observable<HomeViewReactor.Mutation> {
        let createReleaseResponse = homeApiService.request(endPoint: .init(path: .homeRelease)).flatMap { (data: [HomeHotList]) -> Observable<HomeViewReactor.Mutation> in
            
            return .just(.setReleaseItems(data))
        }
        
        return createReleaseResponse
    }
    
    func responseHomeMenuSectionItem(item: [HomeMenuList]) -> HomeViewSection {
        var homeMenuSectionItem: [HomeViewSectionItem] = []
        for i in 0 ..< item.count {
            homeMenuSectionItem.append(.homeMenu(HomeMenuCellReactor(menuType: item[i], homeCellRepo: self)))
        }
        
        return HomeViewSection.field(homeMenuSectionItem)
    }
    
    
    func responseHomeNewsSectionItem(item: [HomeStudyList]) -> HomeViewSection {
        var homeNewsSectionItem: [HomeViewSectionItem] = []
        for i in 0 ..< item.count {
            homeNewsSectionItem.append(.homeStudyList(HomeStudyListReactor(studyNewsModel: item[i], homeNewsRepo: self, studyNewsId: item[i].id)))
        }
        
        return HomeViewSection.homeStudyList(homeNewsSectionItem)
    }
    
    
    
    func responseHomeReleaseSectionItem(item: [HomeHotList]) -> HomeReleaseSection {
        var homeReleaseSectionItem: [HomeRelaseSectionItem] = []
        
        for i in 0 ..< item.count {
            homeReleaseSectionItem.append(.hotList(HomeReleaseCellReactor(releaseModel: item[i], homeReleaseRepo: self, releaseId: item[i].id)))
        }
        
        return HomeReleaseSection.hotMenu(homeReleaseSectionItem)
    }
    
    
    func requestHomeBookMarkItem(id: String) -> Observable<HomeReleaseCellReactor.Mutation> {
        
        let createBookMarkResponse = homeApiService.request(endPoint: .init(path: .homeBookMark(id))).flatMap { (data: HomeBookMarkList) -> Observable<HomeReleaseCellReactor.Mutation> in
            
            return .just(.updateSelected(data))
        }
        return createBookMarkResponse
    }
    
    func requestHomeNewsBookMarkItem(id: String) -> Observable<HomeStudyListReactor.Mutation> {
        
        let createNewsBookMarkResponse = homeApiService.request(endPoint: .init(path: .homeBookMark(id))).flatMap { (data: HomeBookMarkList) -> Observable<HomeStudyListReactor.Mutation> in
            
            return .just(.updateNewsBookMark(data))
        }
        return createNewsBookMarkResponse
    }
}
