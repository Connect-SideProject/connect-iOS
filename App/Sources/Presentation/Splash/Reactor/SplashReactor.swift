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
    case requestNeedsData
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
  
  public let errorHandler: (_ error: Error) -> Observable<Mutation> = { _ in
    return .just(.setIsFinishRequests(true))
  }
  
  private let apiService: ApiService
  private let roleSkillsService: RoleSkillsService
  private let interestService: InterestService
  
  public init(
    apiService: ApiService = ApiManager.shared,
    roleSkillsService: RoleSkillsService = RoleSkillsManager.shared,
    interestService: InterestService = InterestManager.shared
  ) {
    self.apiService = apiService
    self.roleSkillsService = roleSkillsService
    self.interestService = interestService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestNeedsData:
      
      if roleSkillsService.isExists && interestService.isExists {
        return .just(.setIsFinishRequests(true))
      }
      
      let updateRoleSkills = apiService.request(
        endPoint: .init(path: .skills)
      )
      .flatMap { [weak self] (roleSkills: [RoleSkills]) -> Observable<Void> in
          self?.roleSkillsService.update(roleSkills)
          return .just(())
      }
      
      let updateInterests = apiService.request(
        endPoint: .init(path: .interests)
      )
      .flatMap { [weak self] (interests: [Interest]) -> Observable<Void> in
        self?.interestService.update(interests)
        return .just(())
    }
      
      return Observable.combineLatest(
        updateRoleSkills, updateInterests
      ).flatMap { _ -> Observable<Mutation> in
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
