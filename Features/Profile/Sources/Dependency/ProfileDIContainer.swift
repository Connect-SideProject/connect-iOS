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

/// 각 항목 의존성 주입을 위한 컨테이너
/// 추후 라이브러리로 대체 예정..
public final class ProfileDIContainer {
  typealias Repository = ProfileRepositoryImpl
  
  private let apiService: ApiService
  private let userService: UserService
  
  public init(
    apiService: ApiService,
    userService: UserService
  ) {
    self.apiService = apiService
    self.userService = userService
  }
  
  func makeRepository() -> Repository {
    return ProfileRepositoryImpl(
      apiService: apiService
    )
  }
  
  public func makeController() -> ProfileController {
      let controller = ProfileController()
      controller.reactor = .init(
        apiService: apiService,
        userService: userService
      )
      return controller
  }
}
