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
  
  public enum Route {
    case back
  }
  
  public enum Action {
    /// 프로필 요청
    case viewDidLoad
    
    /// 프로필 수정 저장
    case didTapSaveButton(ProfileEditParameter)
  }
  
  public enum Mutation {
    case setProfile(Profile)
    case setRoute(Route?)
    case setMessage(MessageType?)
  }
  
  public struct State {
    var profile: Profile?
    var route: Route?
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
    case let .didTapSaveButton(parameter):
      print(parameter.toJSONString())
      print(parameter.asDictionary())
      
      return .just(.setRoute(.back))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setProfile(profile):
      newState.profile = profile
    case let .setRoute(route):
      newState.route = route
    case let .setMessage(message):
      newState.message = message
    }
    
    return newState
  }
}
