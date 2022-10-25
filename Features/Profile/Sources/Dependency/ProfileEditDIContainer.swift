//
//  ProfileEditDIContainer.swift
//  Profile
//
//  Created by sean on 2022/10/19.
//

import Foundation
import UIKit

import COManager
import CONetwork

/// 각 항목 의존성 주입을 위한 컨테이너
/// 추후 라이브러리로 대체 예정..
public final class ProfileEditDIContainer {
  typealias Repository = ProfileRepositoryImpl
  
  private let apiService: ApiService
  private let userService: UserService
  private let interestService: InterestService
  private let roleSkillsService: RoleSkillsService
  
  public init(
    apiService: ApiService,
    userService: UserService,
    interestService: InterestService,
    roleSkillsService: RoleSkillsService
  ) {
    self.apiService = apiService
    self.userService = userService
    self.interestService = interestService
    self.roleSkillsService = roleSkillsService
  }
  
  func makeRepository() -> Repository {
    return ProfileRepositoryImpl(
      apiService: apiService
    )
  }
  
  public func makeController() -> ProfileEditController {
      let controller = ProfileEditController()
      controller.reactor = .init(
        repository: makeRepository(),
        userService: userService,
        interestService: interestService,
        roleSkillsService: roleSkillsService
      )
      return controller
  }
}
