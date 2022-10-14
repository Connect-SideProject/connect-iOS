//
//  ProfileUseCaseImpl.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import RxSwift
import CODomain
import COManager

final class ProfileUseCaseImpl: ProfileUseCase {
  
  let repository: ProfileRepository
  let userService: UserService
  
  init(repository: ProfileRepository, userService: UserService = UserManager.shared) {
    self.repository = repository
    self.userService = userService
  }
}

extension ProfileUseCaseImpl {
  func getProfile() -> Observable<Profile> {
    return repository.userProfile()
  }
  
  func updateProfile(_ profile: Profile) -> Observable<Profile> {
    return repository.updateProfile(profile)
  }
}
