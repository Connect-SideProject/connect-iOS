//
//  ProfileDIContainer.swift
//  connect
//
//  Created by sean on 2022/08/24.
//

import Foundation
import UIKit

import COManager
import CONetwork

public enum ProfileDIType {
  case base, edit
}

/// 각 항목 의존성 주입을 위한 컨테이너
/// 추후 라이브러리로 대체 예정..
public final class ProfileDIContainer {
  typealias Repository = ProfileRepositoryImpl
  typealias UseCase = ProfileUseCaseImpl
  
  private let apiService: ApiService
  private let userService: UserService
  private let roleSkillsService: RoleSkillsService
  private let type: ProfileDIType
  
  public init(
    apiService: ApiService,
    userService: UserService,
    roleSkillsService: RoleSkillsService,
    type: ProfileDIType
  ) {
    self.apiService = apiService
    self.userService = userService
    self.roleSkillsService = roleSkillsService
    self.type = type
  }
  
  func makeRepository() -> Repository {
    return ProfileRepositoryImpl(
      apiService: apiService,
      userService: userService
    )
  }
  
  func makeUseCase() -> UseCase {
    let repository = makeRepository()
    return ProfileUseCaseImpl(repository: repository)
  }
  
  public func makeController() -> UIViewController {
    if type == .base {
      let controller = ProfileController()
      controller.reactor = .init(
        profileUseCase: makeUseCase()
      )
      return controller
    } else {
      let controller = ProfileEditController(roleSkillsService: roleSkillsService)
      controller.reactor = .init(
        profileUseCase: makeUseCase()
      )
      return controller
    }
  }
}
