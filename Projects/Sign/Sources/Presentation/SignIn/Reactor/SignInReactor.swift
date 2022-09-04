//
//  SignInReactor.swift
//  Sign
//
//  Created by sean on 2022/09/03.
//

import Foundation

import CODomain
import ReactorKit

public final class SignInReactor: Reactor {
  public enum Action {
    case didTapSignInButton(type: AuthType)
  }
  
  public enum Mutation {
    case setAccessToken(String)
    case setProfile(Profile)
  }
  
  public struct State {
    var accessToken: String = ""
    var profile: Profile = .init()
  }
  
  public var initialState: State = .init()
  
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
        }
    default:
      return .empty()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setAccessToken(let accessToken):
      newState.accessToken = accessToken
    case .setProfile(let profile):
      newState.profile = profile
    }
    
    return newState
  }
}
