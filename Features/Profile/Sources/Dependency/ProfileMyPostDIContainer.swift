//
//  ProfileMyPostDIContainer.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/12.
//

import Foundation

import COManager
import CONetwork


public final class ProfileMyPostDIContainer {
    
    typealias Repository = ProfileMyPostRepositoryImpl
    
    //MARK: Property
    private let apiService: ApiService
    private let profilePostType: ProfilePostType
    
    
    public init(apiService: ApiService, profilePostType: ProfilePostType) {
        self.apiService = apiService
        self.profilePostType = profilePostType
    }
    
    func makeRepository() -> Repository {
        return ProfileMyPostRepositoryImpl(
            apiService: apiService
        )
    }
    
    public func makeReactor() -> ProfileMyPostReactor {
        return ProfileMyPostReactor(profilePostType: profilePostType, profileMyPostRepository: makeRepository())
    }
    
    
    public func makeController() -> ProfileMyPostController {
        
        return ProfileMyPostController(reactor: makeReactor())
    }
    
}


