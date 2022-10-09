//
//  ProfileEditReactor.swift
//  Profile
//
//  Created by sean on 2022/10/09.
//

import Foundation

import ReactorKit
import RxCocoa
import COCommonUI
import CODomain
import COManager

public final class ProfileEditReactor: Reactor {
  public enum Action {
    /// 프로필 요청
    case viewDidLoad
  }
  
  public enum Mutation {
    case setProfile(Profile)
    case setMessage(MessageType?)
  }
  
  public struct State {
    var profile: Profile?
    var message: MessageType?
  }
  
  public var initialState: State = .init()
  
  private let profileUseCase: ProfileUseCase
  
  public init(profileUseCase: ProfileUseCase) {
    self.profileUseCase = profileUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return profileUseCase.getProfile()
        .flatMap { profile -> Observable<Mutation> in
          return .just(.setProfile(profile))
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setProfile(profile):
      newState.profile = profile
    case let .setMessage(message):
      newState.message = message
    }
    
    return newState
  }
}
