//
//  SignInReactor.swift
//  Sign
//
//  Created by sean on 2022/09/03.
//

import Foundation

import CODomain
import COExtensions
import COManager
import CONetwork
import ReactorKit

public enum SignInRoute {
  case signUp(AuthType, String), home
}

public final class SignInReactor: Reactor, ErrorHandlerable {
  
  public enum Action {
    case didTapSignInButton(type: AuthType)
  }
  
  public enum Mutation {
    case setRoute(SignInRoute)
    case setError(COError?)
  }
  
  public struct State {
    var route: SignInRoute?
    var error: COError?
  }
  
  public var initialState: State = .init()
  
  public lazy var errorHandler: (_ error: Error) -> Observable<Mutation> = { [weak self] error in
    let error = error.asCOError
    
    if error == .needSignUp {
      guard let authType = self?.authType,
            let accessToken = self?.accessToken else {
        return .empty()
      }
      return .just(.setRoute(.signUp(authType, accessToken)))
    }
    return .just(.setError(error))
  }
  
  private var authType: AuthType? = nil
  private var accessToken: String = ""
  
  private let useCase: SignInUseCase
  private let userService: UserService
  
  public init(useCase: SignInUseCase, userService: UserService = UserManager.shared) {
    self.useCase = useCase
    self.userService = userService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapSignInButton(let authType):
      self.authType = authType
      
      let accessToken: Observable<String> = useCase.accessTokenFromThirdParty(authType: authType)
      
      return accessToken
        .flatMap { [weak self] accessToken -> Observable<Mutation> in
          guard let self = self else { return .empty() }
          self.accessToken = accessToken
          
          return self.signInProcess(authType: authType, accessToken: accessToken)
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setRoute(route):
      newState.route = route
    case let .setError(error):
      newState.error = error
    }
    
    return newState
  }
}

private extension SignInReactor {
  func signInProcess(authType: AuthType, accessToken: String) -> Observable<Mutation> {
    return useCase.signIn(authType: authType, accessToken: accessToken)
      .flatMap { [weak self] profile -> Observable<Mutation> in
        self?.userService.update(tokens: nil, profile: profile)
        return .just(.setRoute(.home))
      }.catch(errorHandler)
  }
}
