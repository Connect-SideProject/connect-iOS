//
//  SignInDIContainer.swift
//  Sign
//
//  Created by sean on 2022/09/05.
//

import Foundation
import UIKit

import COCommon
import CONetwork
import COManager
import ReactorKit

public final class SignInDIContainer: DIContainer {
  public typealias Reactor = SignInReactor
  public typealias Repository = SignInRepository
  public typealias UserCase = SignInUseCase
  public typealias ViewController = SignInController
  
  private let apiService: ApiService
  private let userService: UserService
  
  public init(apiService: ApiService, userService: UserService) {
    self.apiService = apiService
    self.userService = userService
  }
  
  public func makeRepository() -> Repository {
    return SignInRepositoryImpl(apiService: apiService)
  }
  
  public func makeUseCase() -> UserCase {
    return SignInUseCaseImpl(
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
    let controller = SignInController()
    controller.reactor = makeReactor()
    return controller
  }
}
