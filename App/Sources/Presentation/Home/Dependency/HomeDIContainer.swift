//
//  HomeDIContainer.swift
//  App
//
//  Created by Kim dohyun on 2022/10/30.
//

import Foundation
import ReactorKit
import UIKit

import CODomain
import CONetwork
import COCommon
import COManager

//MARK: Dependency
public final class HomeDependencyContainer: HomeDIContainer {
    public typealias HomeReactor = HomeViewReactor
    public typealias HomeViewRepository = HomeRepository
    public typealias HomeViewController = HomeController
    public typealias ChildrenDependency = PostDependencyContainer
    
    private let homeApiService: ApiService
    
    
    public init(
        homeApiService: ApiService
    ) {
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
    func responseInterestMenuItem() -> Observable<HomeViewReactor.Mutation>
    func responseHomeReleaseItem() -> Observable<HomeViewReactor.Mutation>
    func responseHomeMenuImage(image: Interest) async throws -> UIImage
    func responseHomeNewsItem(paramenter: [String: String?]) -> Observable<HomeViewReactor.Mutation>
    func responseHomeReleaseSectionItem(item: [HomeHotList]) -> HomeReleaseSection
    func responseHomeMenuSectionItem(item: [Interest]) -> HomeViewSection
    func responseHomeNewsSectionItem(item: [HomeStudyList]) -> HomeViewSection
    func requestHomeBookMarkItem(id: String) -> Observable<HomeReleaseCellReactor.Mutation>
    func requestHomeNewsBookMarkItem(id: String) -> Observable<HomeStudyListReactor.Mutation>
}


final class HomeViewRepo: HomeRepository {

    //MARK: Property
    private let homeApiService: ApiService
    private let interestService: InterestService
    
    public init(
        homeApiService: ApiService = ApiManager.shared,
        interestService: InterestService = InterestManager.shared
    ) {
        self.homeApiService = homeApiService
        self.interestService = interestService
    }
    
    func responseInterestMenuItem() -> Observable<HomeViewReactor.Mutation> {
        
        return .just(.setHomeInterestMenuItem(interestService.interestList))
    }
    
    func responseHomeMenuImage(image: Interest) async throws -> UIImage {
        let imageTask: Task<UIImage, Error> = Task {
            guard let imageUrl = URL(string: image.imageURL),
                  let (imageData, _) = try? await URLSession.shared.data(from: imageUrl)
            else { return UIImage() }
            return UIImage(data: imageData) ?? UIImage()
        }
        return try await imageTask.value
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
    
    func responseHomeMenuSectionItem(item: [Interest]) -> HomeViewSection {
        var homeMenuSectionItem: [HomeViewSectionItem] = []
        for i in 0 ..< item.count {
            homeMenuSectionItem.append(.homeMenu(HomeMenuCellReactor(menuModel: item[i], menuRepo: self)))
        }
        
        return HomeViewSection.field(homeMenuSectionItem)
    }
    
    
    func responseHomeNewsSectionItem(item: [HomeStudyList]) -> HomeViewSection {
        var homeNewsSectionItem: [HomeViewSectionItem] = []
        for i in 0 ..< item.count {
            homeNewsSectionItem.append(.homeStudyList(HomeStudyListReactor(studyNewsModel: item[i], homeNewsRepo: self)))
        }
        
        return HomeViewSection.homeStudyList(homeNewsSectionItem)
    }
    
    
    
    func responseHomeReleaseSectionItem(item: [HomeHotList]) -> HomeReleaseSection {
        var homeReleaseSectionItem: [HomeRelaseSectionItem] = []
        
        for i in 0 ..< item.count {
            homeReleaseSectionItem.append(.hotList(HomeReleaseCellReactor(releaseModel: item[i], homeReleaseRepo: self)))
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
