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


public final class HomeDIContainer: HomeDIConainer {

    public typealias HomeReactor = HomeViewReactor
    public typealias HomeViewRepository = HomeRepository
    public typealias HomeViewController = HomeController
    
    private let homeApiService: ApiService
    
    
    public init(homeApiService: ApiService) {
        self.homeApiService = homeApiService
    }
    
    deinit {
        print(#function)
    }
    
    
    public func makeHomeReactor() -> HomeViewReactor {
        return HomeViewReactor(homeRepository: makeHomeRepository())
    }
    
    public func makeHomeRepository() -> HomeViewRepository {
        return HomeViewRepo(homeApiService: homeApiService)
    }
    
    public func makeHomeController() -> HomeController {
        return HomeController(reactor: makeHomeReactor())
    }
    
    

}



public protocol HomeRepository {
    func responseMenuImage(image: HomeMenu) throws -> UIImage
    func responseHomeMenuItem() -> Observable<HomeViewReactor.Mutation>
    func responseHomeMenuSectionItem(item: [HomeMenu]) -> HomeViewSection
    func responseHomeReleaseItem() -> Observable<HomeViewReactor.Mutation>
    func responseHomeReleaseSectionItem(item: [HomeHotList]) -> HomeReleaseSection
}


final class HomeViewRepo: HomeRepository {
    
    private let homeApiService: ApiService
    
    public init(homeApiService: ApiService = ApiManager.shared) {
        self.homeApiService = homeApiService
    }
    
    
    func responseMenuImage(image item: HomeMenu) throws -> UIImage {
        guard let imageurl = URL(string: item.menuImage),
              let imageData = try? Data(contentsOf: imageurl) else { return UIImage() }
        return UIImage(data: imageData) ?? UIImage()
    }
    
    
    func responseHomeMenuItem() -> Observable<HomeViewReactor.Mutation> {
        let creteMenuResponse = homeApiService.request(endPoint: .init(path: .homeMenu)).flatMap { (data: [HomeMenu]) -> Observable<HomeViewReactor.Mutation> in
            
            return .just(.setHomeMenuItem(data))
        }
        
        return creteMenuResponse
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
    
    
    func responseHomeReleaseSectionItem(item: [HomeHotList]) -> HomeReleaseSection {
        var homeReleaseSectionItem: [HomeRelaseSectionItem] = []
        
        for i in 0 ..< item.count {
            homeReleaseSectionItem.append(.hotList(HomeReleaseCellReactor(releaseModel: item[i])))
        }
        
        return HomeReleaseSection.hotMenu(homeReleaseSectionItem)
    }
    
    
}
