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
    func responseMenuImage(image: HomeMenu) throws -> Data
    func responseHomeReleaseItem() -> Observable<HomeViewReactor.Mutation>
    func responseHomeMenuItem() -> Observable<HomeViewReactor.Mutation>
    func responseHomeNewsImte() -> Observable<HomeViewReactor.Mutation>
    func responseHomeReleaseSectionItem(item: [HomeHotList]) -> HomeReleaseSection
    func responseHomeMenuSectionItem(item: [HomeMenu]) -> HomeViewSection
    func responseHomeNewsSectionItem(item: [HomeStudyNodeList]) -> HomeViewSection
}


final class HomeViewRepo: HomeRepository {
    
    private let homeApiService: ApiService
    
    public init(homeApiService: ApiService = ApiManager.shared) {
        self.homeApiService = homeApiService
    }
    
    
    func responseMenuImage(image item: HomeMenu) throws -> Data {
        guard let imageurl = URL(string: item.menuImage),
              let imageData = try? Data(contentsOf: imageurl) else { return Data() }
        return UIImage(data: imageData)?.pngData() ?? Data()
    }
    
    
    func responseHomeMenuItem() -> Observable<HomeViewReactor.Mutation> {
        let creteMenuResponse = homeApiService.request(endPoint: .init(path: .homeMenu)).flatMap { (data: [HomeMenu]) -> Observable<HomeViewReactor.Mutation> in
            
            return .just(.setHomeMenuItem(data))
        }
        
        return creteMenuResponse
    }
    
    func responseHomeNewsImte() -> Observable<HomeViewReactor.Mutation> {
        let createNewsResponse = homeApiService.request(endPoint: .init(path: .homeNews)).flatMap { (data: HomeStudyList) -> Observable<HomeViewReactor.Mutation> in
            
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
    
    func responseHomeMenuSectionItem(item: [HomeMenu]) -> HomeViewSection {
        var homeMenuSectionItem: [HomeViewSectionItem] = []
        for i in 0 ..< item.count {
            homeMenuSectionItem.append(.homeMenu(HomeMenuCellReactor(menuType: item[i], homeCellRepo: self)))
        }
        
        return HomeViewSection.field(homeMenuSectionItem)
    }
    
    
    func responseHomeNewsSectionItem(item: [HomeStudyNodeList]) -> HomeViewSection {
        var homeNewsSectionItem: [HomeViewSectionItem] = []
        for i in 0 ..< item.count {
            homeNewsSectionItem.append(.homeStudyList(HomeStudyListReactor(studyNewsModel: item[i])))
        }
        
        return HomeViewSection.homeStudyList(homeNewsSectionItem)
    }
    
    
    
    func responseHomeReleaseSectionItem(item: [HomeHotList]) -> HomeReleaseSection {
        var homeReleaseSectionItem: [HomeRelaseSectionItem] = []
        
        for i in 0 ..< item.count {
            homeReleaseSectionItem.append(.hotList(HomeReleaseCellReactor(releaseModel: item[i])))
        }
        
        return HomeReleaseSection.hotMenu(homeReleaseSectionItem)
    }
    
    
}
