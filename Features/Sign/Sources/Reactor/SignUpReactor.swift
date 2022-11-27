//
//  SignUpReactor.swift
//  Sign
//
//  Created by sean on 2022/09/19.
//

import Foundation

import ReactorKit

import COCommonUI
import CODomain
import COExtensions
import CONetwork
import COManager

public final class SignUpReactor: Reactor, ErrorHandlerable {
  
  public enum Route {
    case home
    case bottomSheet([BottomSheetItem<법정주소>])
  }
  
  public enum Action {
    case didTapAddressButton
    case didSelectedLocation(Int)
    case didTapSignUpButton(SignUpParameter)
  }
  
  public enum Mutation {
    case setAddressList([BottomSheetItem<법정주소>])
    case setInterestList([Interest])
    case setRoleSkillsList([RoleSkills])
    case setRegion(Region?)
    case setRoute(Route?)
    case setError(COError?)
  }
  
  public struct State {
    var addressList: [BottomSheetItem<법정주소>] = []
    var interestList: [Interest] = []
    var roleSkillsList: [RoleSkills] = []
    var region: Region?
    @Pulse var route: Route?
    @Pulse var error: COError?
  }
  
  public var initialState: State = .init()
  
  public var errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asCOError))
  }
  
  private let useCase: SignUpUseCase
  private let userService: UserService
  private let addressService: AddressService
  private let interestService: InterestService
  private let roleSkillsService: RoleSkillsService
  
  private let authType: AuthType
  private let accessToken: String
  
  public init(
    useCase: SignUpUseCase,
    userService: UserService,
    addressService: AddressService,
    interestService: InterestService,
    roleSkillsService: RoleSkillsService,
    authType: AuthType,
    accessToken: String
  ) {
    self.useCase = useCase
    self.userService = userService
    self.addressService = addressService
    self.interestService = interestService
    self.roleSkillsService = roleSkillsService
    
    self.authType = authType
    self.accessToken = accessToken
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    
    let accessToken = accessToken
    
    switch action {
    case .didTapAddressButton:
      return Observable.just(currentState.addressList)
        .flatMap { addressList -> Observable<Mutation> in
          return .just(.setRoute(.bottomSheet(addressList)))
        }
      
    case let .didSelectedLocation(index):
      
      guard let address = currentState.addressList[safe: index] else { return .empty() }
      
      let region = Region(
        code: address.value.법정코드,
        name: address.value.법정동명
      )
      
      var addressList = currentState.addressList
      
      let _ = addressList.indices.map { offset in
        addressList[offset].update(isSelected: false)
      }
      
      addressList[index].update(isSelected: true)
      
      let setAddressList: Observable<Mutation> = .just(.setAddressList(addressList))
      
      return .just(.setRegion(region))
        .concat(setAddressList)
      
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
        return .just(.setError(COError.message(nil, "지역을 선택 해주세요.")))
      }
      
      guard parameter.checkedTermsCount() == 3 else {
        return .just(.setError(COError.message(nil, "필수 항목을 모두 체크해주세요.")))
      }
      
      let interestings = interestService.interestList
        .enumerated()
        .map { offset, element in
          return parameter._interestings.filter {
            element.name == $0
          }.map { _ in element }
        }
        .flatMap { $0 }
      
      let roles = roleSkillsService.roleSkillsList
        .enumerated()
        .map { offset, element in
          return parameter._roles.filter {
            RoleType(description: element.roleName) == $0
          }.map { Role(type: $0) }
        }
        .flatMap { $0 }
      
      var parameter = parameter
      parameter.updateAuthType(authType)
      parameter.updateRegion(region)
      parameter.updateInterestings(interestings)
      parameter.updateRoles(roles)
      
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
    case let .setAddressList(addressList):
      newState.addressList = addressList
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

