//
//  SignUpDIContainer.swift
//  Sign
//
//  Created by sean on 2022/09/24.
//

import Foundation
import UIKit

import COCommon
import CONetwork
import COManager
import ReactorKit

public final class SignUpDIContainer: DIContainer {
  public typealias Reactor = SignUpReactor
  public typealias Repository = SignUpRepository
  public typealias UserCase = SignUpUseCase
  public typealias ViewController = SignUpController
  
  private let apiService: ApiService
  private let userService: UserService
  
  public init(apiService: ApiService, userService: UserService) {
    self.apiService = apiService
    self.userService = userService
  }
  
  public func makeRepository() -> Repository {
    return SignUpRepositoryImpl(apiService: apiService)
  }
  
  public func makeUseCase() -> UserCase {
    return SignUpUseCaseImpl(
      repository: makeRepository(),
      userService: userService
    )
  }
  
  public func makeReactor() -> Reactor {
    return Reactor(
      useCase: makeUseCase()
    )
  }
  
  public func makeController() -> ViewController {
    let controller = SignUpController()
    controller.reactor = makeReactor()
    return controller
  }
}
