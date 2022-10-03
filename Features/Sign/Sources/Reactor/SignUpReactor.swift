//
//  SignUpReactor.swift
//  Sign
//
//  Created by sean on 2022/09/19.
//

import Foundation

import CODomain
import COExtensions
import ReactorKit

public final class SignUpReactor: Reactor, ErrorHandlerable {
  public enum Action {
    case searchAddress(String)
    case didTapSignUpButton(SignUpParameter)
  }
  
  public enum Mutation {
    case setRegion(Region?)
    case setProfile(Profile?)
    case setError(URLError?)
  }
  
  public struct State {
    var region: Region?
    var profile: Profile?
    var error: URLError?
  }
  
  public var initialState: State = .init()
  
  public var errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asURLError))
  }
  
  private let useCase: SignUpUseCase
  private let authType: AuthType
  private let accessToken: String
  
  public init(useCase: SignUpUseCase, authType: AuthType, accessToken: String) {
    self.useCase = useCase
    self.authType = authType
    self.accessToken = accessToken
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .searchAddress(query):
      return useCase.getRegionList(query: query)
        .flatMap { regionList -> Observable<Mutation> in
          guard let resion = regionList.first else { return .empty() }
          return .just(.setRegion(resion))
        }
      
    case let .didTapSignUpButton(parameter):
      guard let region = currentState.region else {
        return .just(.setError(URLError(.dataNotAllowed)))
      }
      
      guard parameter.checkedTermsCount() == 3 else {
        return .just(.setError(URLError(.dataNotAllowed)))
      }
      
      var parameter = parameter
      parameter.updateAuthType(authType)
      parameter.updateRegion(region)
      print(parameter)
      
      return useCase.signUp(parameter: parameter)
        .debug()
        .flatMap { profile -> Observable<Mutation> in
          return .just(.setProfile(profile))
        }.catch(errorHandler)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setRegion(region):
      newState.region = region
    case let .setProfile(profile):
      newState.profile = profile
    case let .setError(error):
      newState.error = error
    }
    
    return newState
  }
}

