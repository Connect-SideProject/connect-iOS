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
  
  public enum Route {
    case home
  }
  
  public enum Action {
    case viewDidLoad
    case searchAddress(String)
    case didTapSignUpButton(SignUpParameter)
  }
  
  public enum Mutation {
    case setInterestList([Interest])
    case setRoleSkillsList([RoleSkills])
    case setRegion(Region?)
    case setRoute(Route?)
    case setError(COError?)
  }
  
  public struct State {
    var interestList: [Interest] = []
    var roleSkillsList: [RoleSkills] = []
    var region: Region?
    var route: Route?
    var error: COError?
  }
  
  public var initialState: State = .init()
  
  public var errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asCOError))
  }
  
  private let useCase: SignUpUseCase
  private let userService: UserService
  private let interestService: InterestService
  private let roleSkillsService: RoleSkillsService
  
  private let authType: AuthType
  private let accessToken: String
  
  public init(
    useCase: SignUpUseCase,
    userService: UserService,
    interestService: InterestService,
    roleSkillsService: RoleSkillsService,
    authType: AuthType,
    accessToken: String
  ) {
    self.useCase = useCase
    self.userService = userService
    self.interestService = interestService
    self.roleSkillsService = roleSkillsService
    
    self.authType = authType
    self.accessToken = accessToken
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    
    let accessToken = accessToken
    
    switch action {
    case .viewDidLoad:
      let setInterestList: Observable<Mutation> = .just(.setInterestList(interestService.interestList))
      let setRoleSkillsList: Observable<Mutation> = .just(.setRoleSkillsList(roleSkillsService.roleSkillsList))
      return setInterestList
        .concat(setRoleSkillsList)
      
    case let .searchAddress(query):
      return useCase.getRegionList(query: query)
        .flatMap { regionList -> Observable<Mutation> in
          guard let resion = regionList.first else { return .empty() }
          return .just(.setRegion(resion))
        }
      
    case let .didTapSignUpButton(parameter):
      
      if parameter.isNicknameEmpty() {
        return .just(.setError(COError.message(nil, "닉네임을 입력 해주세요.")))
      }
      
      if parameter.isCarrerNil() {
        return .just(.setError(COError.message(nil, "경력기간을 선택 해주세요.")))
      }
      
      if parameter.isInterestingsEmpty() {
        return .just(.setError(COError.message(nil, "관심분야를 최소 하나이상 선택 해주세요.")))
      }
      
      if parameter.isRolesEmpty() {
        return .just(.setError(COError.message(nil, "원하는 역할을 선택 해주세요.")))
      }
      
      if parameter.isSkillsEmpty() {
        return .just(.setError(COError.message(nil, "보유스킬을 최소 하나이상 선택 해주세요.")))
      }
      
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
          self?.userService.update(tokens: nil, profile: profile)
          return .just(.setRoute(.home))
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

