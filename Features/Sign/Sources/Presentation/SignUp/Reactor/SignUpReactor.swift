//
//  SignUpReactor.swift
//  Sign
//
//  Created by sean on 2022/09/19.
//

import Foundation

import CODomain
import ReactorKit

public final class SignUpReactor: Reactor {
  public enum Action {
    case didTapSignUpButton(SignUpParameter)
  }
  
  public enum Mutation {
    case setError(URLError?)
  }
  
  public struct State {
    var error: URLError?
  }
  
  public var initialState: State = .init()
  
  private let errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asURLError))
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapSignUpButton(let parameter):
      print(parameter.toJSONString())
    }
    
    return .empty()
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setError(error):
      newState.error = error
    }
    
    return newState
  }
}

