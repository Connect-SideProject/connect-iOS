//
//  SplashReactor.swift
//  AppTests
//
//  Created by sean on 2022/09/25.
//

import Foundation

import CODomain
import COExtensions
import COManager
import CONetwork
import ReactorKit

public final class SplashReactor: Reactor, ErrorHandlerable {
  public enum Action {
    case requestRolesAndSkills
  }
  
  public enum Mutation {
    case setIsFinishRequests(Bool)
    case setError(COError?)
  }
  
  public struct State {
    var isFinishRequests: Bool = false
    var error: COError?
  }
  
  public var initialState: State = .init()
  
  public let errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asCOError))
  }
  
  private let apiService: ApiService
  private let roleSkillsService: RoleSkillsService
  
  public init(
    apiService: ApiService = ApiManager.shared,
    roleSkillsService: RoleSkillsService = RoleSkillsManager.shared
  ) {
    self.apiService = apiService
    self.roleSkillsService = roleSkillsService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestRolesAndSkills:
      
      if roleSkillsService.isExists {
        return .just(.setIsFinishRequests(true))
      }
      
      return apiService.request(endPoint: .init(path: .allSkills))
        .flatMap { [weak self] (roleSkills: [RoleSkills]) -> Observable<Mutation> in
            self?.roleSkillsService.update(roleSkills)
            return .just(.setIsFinishRequests(true))
        }.catch(errorHandler)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setIsFinishRequests(isFinishRequests):
      newState.isFinishRequests = isFinishRequests
    case let .setError(error):
      newState.error = error
    }
    
    return newState
  }
}
