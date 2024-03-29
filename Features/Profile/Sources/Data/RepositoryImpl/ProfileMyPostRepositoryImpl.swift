//
//  ProfileMyPostRepositoryImpl.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/12.
//

import Foundation

import ReactorKit
import CODomain
import CONetwork


final class ProfileMyPostRepositoryImpl: ProfileMyPostRepository {
    
    //MARK: Property
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
}

extension ProfileMyPostRepositoryImpl {
    
    func responseMyPostStudyItem() -> Observable<ProfileMyPostReactor.Mutation> {
        let createMyStudyResponse = apiService.request(endPoint: .init(path: .myStudy)).flatMap { (data: [ProfileStudy]) -> Observable<ProfileMyPostReactor.Mutation> in
            
            return .just(.setmyStudyItem(data))
        }
        
        return createMyStudyResponse
    }
    
    func responseMyPostBookMarkItem() -> Observable<ProfileMyPostReactor.Mutation> {
        let createMyBookMarkResponse = apiService.request(endPoint: .init(path: .myBookMark)).flatMap { (data: [ProfileBookMark]) -> Observable<ProfileMyPostReactor.Mutation> in
            
            return .just(.setmyBookMarkItem(data))
        }
        
        
        return createMyBookMarkResponse
    }
    
    func responseMyPostSectionItem(item: [ProfileStudy]) -> ProfileMyPostSection {
        var myPostSectionItem: [ProfileMyPostSectionItem] = []
        
        for i in 0 ..< item.count {
            myPostSectionItem.append(.myProfilePostItem(MyProfilePostListCellReactor(myStudyModel: item[i], profileStudyRepo: self)))
        }
        
        return ProfileMyPostSection.myProfilePost(myPostSectionItem)
        
    }
    
    func responseMyBookMarkSectionItem(item: [ProfileBookMark]) -> ProfileMyPostSection {
        var myBookMarkSectionItem: [ProfileMyPostSectionItem] = []
        
        for i in 0 ..< item.count {
            myBookMarkSectionItem.append(.myProfileBookMarkItem(MyProfileBookMarkListCellReactor(myBookMarkListModel: item[i], profileRepo: self)))
        }
        
        return ProfileMyPostSection.myProfileBookMark(myBookMarkSectionItem)
    }
    
    
    func requestMyBookMarkItem(id: String) -> Observable<MyProfileBookMarkListCellReactor.Mutation> {
        let createMyBookMarkResponse = apiService.request(endPoint: .init(path: .homeBookMark(id))).flatMap { (data: HomeBookMarkList) -> Observable<MyProfileBookMarkListCellReactor.Mutation> in
            
            return .just(.updateMyPostBookMark(data))
        }

        return createMyBookMarkResponse
    }

    
    func requestMyStudyBookMarkItem(id: String) -> Observable<MyProfilePostListCellReactor.Mutation> {
        let createMyStudyBookMarkResponse = apiService.request(endPoint: .init(path: .homeBookMark(id))).flatMap { (data: HomeBookMarkList) -> Observable<MyProfilePostListCellReactor.Mutation> in
            
            return .just(.updateMyStudyBookMark(data))
        }
        
        return createMyStudyBookMarkResponse
    }
    
}
