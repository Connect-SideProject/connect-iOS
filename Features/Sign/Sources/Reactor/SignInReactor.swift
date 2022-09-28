//
//  SignInReactor.swift
//  Sign
//
//  Created by sean on 2022/09/03.
//

import Foundation

import CODomain
import COExtensions
import ReactorKit

public final class SignInReactor: Reactor, ErrorHandlerable {
  public enum Action {
    case didTapSignInButton(type: AuthType)
  }
  
  public enum Mutation {
    case setProfile(Profile?)
    case setError(URLError?)
  }
  
  public struct State {
    var profile: Profile?
    var error: URLError?
  }
  
  public var initialState: State = .init()
  
  public let errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asURLError))
  }
  
  private let useCase: SignInUseCase
  
  public init(useCase: SignInUseCase) {
    self.useCase = useCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapSignInButton(let type):
      return useCase.signIn(authType: type)
        .flatMap { profile -> Observable<Mutation> in
          return .just(.setProfile(profile))
        }.catch(errorHandler)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setProfile(profile):
      newState.profile = profile
    case let .setError(error):
      newState.error = error
    }
    
    return newState
  }
}
