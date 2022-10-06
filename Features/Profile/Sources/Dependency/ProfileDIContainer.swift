//
//  ProfileDIContainer.swift
//  connect
//
//  Created by sean on 2022/08/24.
//

import Foundation

import CONetwork

/// 각 항목 의존성 주입을 위한 컨테이너
/// 추후 라이브러리로 대체 예정..
public final class ProfileDIContainer {
  typealias Repository = ProfileRepositoryImpl
  typealias UseCase = ProfileUseCaseImpl
  public typealias Controller = ProfileController
  
  private let apiService: ApiService
  
  public init(apiService: ApiService) {
    self.apiService = apiService
  }
  
  func makeRepository() -> Repository {
    return ProfileRepositoryImpl(
      apiService: apiService
    )
  }
  
  func makeUseCase() -> UseCase {
    let repository = makeRepository()
    return ProfileUseCaseImpl(repository: repository)
  }
  
  public func makeController() -> Controller {
    let controller = Controller()
    controller.reactor = .init(
      profileUseCase: makeUseCase()
    )
    return controller
  }
}
