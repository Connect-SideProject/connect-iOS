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
    case setRegions([Region])
    case setProfile(Profile?)
    case setError(URLError?)
  }
  
  public struct State {
    var regions: [Region] = []
    var profile: Profile?
    var error: URLError?
  }
  
  public var initialState: State = .init()
  
  public let errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asURLError))
  }
  
  private let useCase: SignUpUseCase
  
  public init(useCase: SignUpUseCase) {
    self.useCase = useCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .searchAddress(query):
      return useCase.getRegionList(query: query)
        .flatMap { regionList -> Observable<Mutation> in
          return .just(.setRegions(regionList))
        }
      
    case let .didTapSignUpButton(parameter):
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
    case let .setRegions(regions):
      newState.regions = regions
    case let .setProfile(profile):
      newState.profile = profile
    case let .setError(error):
      newState.error = error
    }
    
    return newState
  }
}

