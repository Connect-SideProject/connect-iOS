//
//  SignUpReactor.swift
//  Sign
//
//  Created by sean on 2022/09/19.
//

import Foundation

import ReactorKit

import CODomain
import COExtensions
import CONetwork
import COManager

public final class SignUpReactor: Reactor, ErrorHandlerable {
  public enum Action {
    case searchAddress(String)
    case didTapSignUpButton(SignUpParameter)
  }
  
  public enum Mutation {
    case setRegion(Region?)
    case setProfile(Profile?)
    case setError(COError?)
  }
  
  public struct State {
    var region: Region?
    var profile: Profile?
    var error: COError?
  }
  
  public var initialState: State = .init()
  
  public var errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asCOError))
  }
  
  private let useCase: SignUpUseCase
  private let userService: UserService
  private let authType: AuthType
  private let accessToken: String
  
  public init(
    useCase: SignUpUseCase,
    userService: UserService = UserManager.shared,
    authType: AuthType,
    accessToken: String
  ) {
    self.useCase = useCase
    self.userService = userService
    self.authType = authType
    self.accessToken = accessToken
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    
    let accessToken = accessToken
    
    switch action {
    case let .searchAddress(query):
      return useCase.getRegionList(query: query)
        .flatMap { regionList -> Observable<Mutation> in
          guard let resion = regionList.first else { return .empty() }
          return .just(.setRegion(resion))
        }
      
    case let .didTapSignUpButton(parameter):
      guard let region = currentState.region else {
        return .just(.setError(COError.message(nil, "지역을 검색 해주세요.")))
      }
      
      guard parameter.checkedTermsCount() == 3 else {
        return .just(.setError(COError.message(nil, "필수 항목을 모두 체크해주세요.")))
      }
      
      var parameter = parameter
      parameter.updateAuthType(authType)
      parameter.updateRegion(region)
      
      return useCase.signUp(parameter: parameter, accessToken: accessToken)
        .debug()
        .flatMap { [weak self] profile -> Observable<Mutation> in
          self?.userService.update(accessToken: accessToken, profile: profile)
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

