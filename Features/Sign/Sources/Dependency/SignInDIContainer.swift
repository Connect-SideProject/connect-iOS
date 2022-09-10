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
  private var delegate: SignInDelegate?
  
  public init(apiService: ApiService, userService: UserService, delegate: SignInDelegate? = nil) {
    self.apiService = apiService
    self.userService = userService
    self.delegate = delegate
  }
  
  public func makeSignInRepository() -> Repository {
    return SignInRepositoryImpl(apiService: apiService)
  }
  
  public func makeSignInUseCase() -> UserCase {
    return SignInUseCaseImpl(
      repository: makeSignInRepository(),
      userService: userService
    )
  }
  
  public func makeReactor() -> Reactor {
    return Reactor(
      useCase: makeSignInUseCase()
    )
  }
  
  public func makeController() -> ViewController {
    let controller = SignInController()
    controller.delegate = delegate
    controller.reactor = makeReactor()
    return controller
  }
}
