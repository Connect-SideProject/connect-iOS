//
//  ProfileEditReactor.swift
//  Profile
//
//  Created by sean on 2022/10/09.
//

import Foundation
import UIKit

import ReactorKit
import RxCocoa
import COCommonUI
import CODomain
import COManager
import CONetwork

public final class ProfileEditReactor: Reactor {
  
  public enum Route {
    case back
  }
  
  public enum Action {
    
    /// 프로필 요청.
    case viewDidLoad
    
    /// 프로필 이미지 업로드 요청.
    case requestUploadImage(Data?)
    
    /// 프로필 수정 저장.
    case didTapSaveButton(ProfileEditParameter)
  }
  
  public enum Mutation {
    case setInterestList([Interest])
    case setRoleSkillsList([RoleSkills])
    case setImageURL(URL?)
    case setProfile(Profile?)
    case setRegion(Region?)
    case setRoute(Route?)
    case setError(COError?)
  }
  
  public struct State {
    var interestList: [Interest] = []
    var roleSkillsList: [RoleSkills] = []
    var imageURL: URL?
    var profile: Profile?
    var region: Region?
    var route: Route?
    var error: COError?
  }
  
  public var initialState: State
  
  public var errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asCOError))
  }
  
  private let iamgeLoader: ImageLoader = .init()
  
  private let repository: ProfileRepository
  private let userService: UserService
  private let interestService: InterestService
  private let roleSkillsService: RoleSkillsService
  
  public init(
    repository: ProfileRepository,
    userService: UserService,
    interestService: InterestService,
    roleSkillsService: RoleSkillsService
  ) {
    self.repository = repository
    self.userService = userService
    self.interestService = interestService
    self.roleSkillsService = roleSkillsService
    
    self.initialState = .init(
      region: userService.profile?.region
    )
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      let setInterestList: Observable<Mutation> = .just(.setInterestList(interestService.interestList))
      let setRoleSkillsList: Observable<Mutation> = .just(.setRoleSkillsList(roleSkillsService.roleSkillsList))
      let setProfile: Observable<Mutation> = .just(.setProfile(userService.profile))
      return setInterestList
        .concat(setRoleSkillsList)
        .concat(setProfile)
    
    case let .requestUploadImage(data):
      
      guard let data = data else {
        return .just(.setError(.message("Error", "올바르지 않은 이미지입니다.")))
      }
      
      return repository.uploadProfileImage(data: data)
        .flatMap { imageURL -> Observable<Mutation> in
          let imageURL = URL(string: imageURL)
          return .just(.setImageURL(imageURL))
        }
      
    case let .didTapSaveButton(parameter):
      var parameter = parameter
      
        let codes: [String] = interestService.interestList
        .enumerated()
        .map { offset, element in
          parameter.interestings.map {
            if element.name == $0 {
              return element.code
            }
            
            return ""
          }
          .filter { !$0.isEmpty }
        }
        .flatMap { $0 }
      
      parameter.updateInterestings(codes)
      
      return repository.updateProfile(parameter: parameter)
        .flatMap { [weak self] profile -> Observable<Mutation> in
          self?.userService.update(
            tokens: nil,
            profile: profile
          )
          
          return .just(.setRoute(.back))
        }.catch(errorHandler)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setInterestList(interestList):
      newState.interestList = interestList
    case let .setRoleSkillsList(roleSkillsList):
      newState.roleSkillsList = roleSkillsList
    case let .setImageURL(imageURL):
      newState.imageURL = imageURL
    case let .setProfile(profile):
      newState.profile = profile
    case let .setRegion(region):
      newState.region = region
    case let .setRoute(route):
      newState.route = route
    case let .setError(error):
      newState.error = error
    }
    
    return newState
  }
}
