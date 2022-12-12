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
    
    private let apiService: ApiService
    
    
    public init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func makeRepository() -> Repository {
        return ProfileMyPostRepositoryImpl(
            apiService: apiService
        )
    }
    
    func makeReactor(_ type: ProfilePostType) -> ProfileMyPostReactor {
        return ProfileMyPostReactor(profilePostType: type, profileMyPostRepository: makeRepository())
    }
    
    
    func makeController(_ type: ProfilePostType) -> ProfileMyPostController {
        
        return ProfileMyPostController(reactor: makeReactor(type))
    }
    
}


