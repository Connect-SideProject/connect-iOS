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
        
    let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
}

extension ProfileMyPostRepositoryImpl {
    
    func responseMyPostStudyItem() -> Observable<ProfileMyPostReactor.Mutation> {
        let createMyStudyResponse = apiService.request(endPoint: .init(path: .myStudy)).flatMap { (data: [ProfileStudy]) -> Observable<ProfileMyPostReactor.Mutation> in
            
            return .just(.setMyStudyItem(data))
        }
        
        return createMyStudyResponse
    }
    
    func responseMyPostBookMarkItem() -> Observable<ProfileMyPostReactor.Mutation> {
        let createMyBookMarkResponse = apiService.request(endPoint: .init(path: .myBookMark)).flatMap { (data: [ProfileBookMark]) -> Observable<ProfileMyPostReactor.Mutation> in
            
            return .just(.setMyBookMarkItem(data))
        }
        
        
        return createMyBookMarkResponse
    }
    
    func responseMyPostSectionItem(item: [ProfileStudy]) -> ProfileMyPostSection {
        var myPostSectionItem: [ProfileMyPostSectionItem] = []
        
        for i in 0 ..< item.count {
            myPostSectionItem.append(.myProfilePostItem(MyProfilePostListCellReactor(myStudyModel: item[i])))
        }
        
        return ProfileMyPostSection.myProfilePost(myPostSectionItem)
        
    }
    
}
