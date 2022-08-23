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

/// Profile
enum ProfileSubtitle: String, CustomStringConvertible {
  var description: String {
    switch self {
    case .location:
      return "활동지역"
    case .attentions:
      return "관심분야"
    case .portfolio:
      return "포트폴리오"
    case .career:
      return "경력"
    case .skills:
      return "보유스킬"
    }
  }
  
  case location, attentions, portfolio, career, skills
}

typealias ProfileSubItem = (subtitle: String, content: String)

final class ProfileReactor: Reactor {
  enum Action {
    /// 프로필 요청
    case requestProfile
  }
  
  enum Mutation {
    case setProfile(Profile)
    case setProfileSubItems([ProfileSubItem])
    case setMessage(MessageType?)
  }
  
  struct State {
    var profile: Profile?
    var profileSubItems: [ProfileSubItem]?
    var message: MessageType?
  }
  
  var initialState: State = .init()
  
  let profileUseCase: ProfileUseCase
  
  init(profileUseCase: ProfileUseCase) {
    self.profileUseCase = profileUseCase
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestProfile:
      return profileUseCase.getProfile()
        .debug()
        .flatMap { profile -> Observable<Mutation> in
          
          typealias Items = (ProfileSubtitle, String)
          
          // 타입을 활용하여 타이틀과 해당 내용 표시를 위해 처리.
          let items: [Items] = [
            (.location, profile.location),
            (.attentions, profile.attentions),
            (.portfolio, profile.portfolioURL),
            (.career, profile.career),
            (.skills, profile.skills.enumerated().map { offset, element -> String in
              return offset != profile.skills.count - 1 ? "\(element), " : "\(element)"
            }.reduce("") { $0 + $1 })
          ]
          
          // 뷰에서 보여지는 최종 형태로 변환.
          let profileSubItems: [ProfileSubItem] = items.map { (subtitle: $0.description, content: $1) }
          
          return Observable.just(.setProfile(profile))
            .concat(Observable.just(.setProfileSubItems(profileSubItems)))
        }.catch { _ in
          // 미로그인과 그외 에러 구분처리 필요.
          return .just(.setMessage(.needSignIn))
        }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setProfile(profile):
      newState.profile = profile
    case let .setProfileSubItems(profileSubItems):
      newState.profileSubItems = profileSubItems
    case let .setMessage(message):
      newState.message = message
    }
    
    return newState
  }
}
