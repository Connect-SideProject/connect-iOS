//
//  ProfileReactor.swift
//  connect
//
//  Created by sean on 2022/07/14.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import ReactorKit
import RxCocoa
import COCommonUI
import CODomain
import COExtensions
import COManager
import CONetwork

/// Profile
enum ProfileSubtitle: String, CustomStringConvertible {
  case location, interestings, portfolio, career, skills
  
  var description: String {
    switch self {
    case .location:
      return "활동지역"
    case .interestings:
      return "관심분야"
    case .portfolio:
      return "포트폴리오"
    case .career:
      return "경력"
    case .skills:
      return "보유스킬"
    }
  }
}

public typealias ProfileViewItem = (title: String, content: String)

public final class ProfileReactor: Reactor, ErrorHandlerable {
  
  public enum Route {
    case routeToSignIn
  }
  
  public enum Action {
    /// 프로필 요청
    case requestProfile
    
    /// 로그아웃 요청
    case requestLogout
    
    /// 회원탈퇴 요청
    case requestSignOut
  }
  
  public enum Mutation {
    case setProfile(Profile)
    case setProfileViewItems([ProfileViewItem])
    case setRoute(Route?)
    case setMessage(MessageType?)
  }
  
  public struct State {
    var profile: Profile?
    var profileViewItems: [ProfileViewItem]?
    @Pulse var route: Route?
    var message: MessageType?
  }
  
  public var initialState: State = .init()
  
  public lazy var errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setMessage(.message(error.localizedDescription)))
  }
  
  private let apiService: ApiService
  private let userService: UserService
  
  public init(apiService: ApiService, userService: UserService) {
    self.apiService = apiService
    self.userService = userService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestProfile:
      
      guard let profile = userService.profile else {
        return .just(.setMessage(.message("프로필 정보 없음.")))
      }
      
      return Observable.just(profile)
        .debug()
        .flatMap { profile -> Observable<Mutation> in
          
          typealias Items = (ProfileSubtitle, String)
          
          // 타입을 활용하여 타이틀과 해당 내용 표시를 위해 처리.
          let items: [Items] = [
            (.location, profile.region?.description ?? ""),
            (.interestings, profile.interestings.map { $0.description }.toStringWithComma),
            (.portfolio, profile.portfolioURL ?? ""),
            (.career, profile.career?.description ?? "")
          ]
          
          // 뷰에서 보여지는 최종 형태로 변환.
          let profileViewItems: [ProfileViewItem] = items.map { (title: $0.description, content: $1) }
          
          let setProfile: Observable<Mutation> = Observable.just(.setProfile(profile))
          let setProfileViewItems: Observable<Mutation> = Observable.just(.setProfileViewItems(profileViewItems))
          
          return setProfile.concat(setProfileViewItems)
        }.catch { _ in
          // 미로그인과 그외 에러 구분처리 필요.
          return .just(.setMessage(.needSignIn))
        }
      
    case .requestLogout:
      return apiService.request(endPoint: .init(path: .logout))
        .flatMap { [weak self] (data: EmptyResponse) -> Observable<Mutation> in
          self?.userService.remove()
          return .just(.setRoute(.routeToSignIn))
        }
      
    case .requestSignOut:
      return apiService.request(endPoint: .init(path: .signOut))
        .flatMap { [weak self] (data: EmptyResponse) -> Observable<Mutation> in
          self?.userService.remove()
          return .just(.setRoute(.routeToSignIn))
        }.catch(errorHandler)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setProfile(profile):
      newState.profile = profile
    case let .setProfileViewItems(profileViewItems):
      newState.profileViewItems = profileViewItems
    case let .setRoute(route):
      newState.route = route
    case let .setMessage(message):
      newState.message = message
    }
    
    return newState
  }
}
