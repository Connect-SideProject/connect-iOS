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
    case bottomSheet([BottomSheetItem<법정주소>])
  }
  
  public enum Action {
    
    /// 프로필 요청.
    case viewDidLoad
    
    /// 프로필 이미지 업로드 요청.
    case requestUploadImage(Data?)
    
    /// 프로필 수정 저장.
    case didTapSaveButton(ProfileEditParameter)
    
    /// 활동 지역 선택.
    case didTapAddressButton
    case didSelectedLocation(Int)
  }
  
  public enum Mutation {
    case setAddressList([BottomSheetItem<법정주소>])
    case setInterestList([Interest])
    case setRoleSkillsList([RoleSkills])
    case setImageURL(URL?)
    case setProfile(Profile?)
    case setRegion(Region?)
    case setRoute(Route?)
    case setError(COError?)
  }
  
  public struct State {
    var addressList: [BottomSheetItem<법정주소>] = []
    var interestList: [Interest] = []
    var roleSkillsList: [RoleSkills] = []
    var imageURL: URL?
    @Pulse var profile: Profile?
    var region: Region?
    @Pulse var route: Route?
    var error: COError?
  }
  
  public var initialState: State
  
  public var errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asCOError))
  }
  
  private let iamgeLoader: ImageLoader = .init()
  
  private let repository: ProfileRepository
  private let userService: UserService
  private let addressService: AddressService
  private let interestService: InterestService
  private let roleSkillsService: RoleSkillsService
  
  public init(
    repository: ProfileRepository,
    userService: UserService,
    addressService: AddressService,
    interestService: InterestService,
    roleSkillsService: RoleSkillsService
  ) {
    self.repository = repository
    self.userService = userService
    self.addressService = addressService
    self.interestService = interestService
    self.roleSkillsService = roleSkillsService
    
    var addressList = addressService.addressList.map { BottomSheetItem<법정주소>(value: $0) }
    let index = addressList.enumerated()
      .map { offset, element in
        return element.value.법정동명 == userService.profile?.region?.description ? offset : -1
      }
      .filter { $0 != -1 }
      .reduce(0, +)
    
    addressList[index].update(isSelected: true)
    
    self.initialState = .init(
      addressList: addressList,
      region: userService.profile?.region
    )
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      let setAddressList: Observable<Mutation> = .just(.setAddressList(addressService.addressList.map { BottomSheetItem(value: $0) }))
      let setInterestList: Observable<Mutation> = .just(.setInterestList(interestService.interestList))
      let setRoleSkillsList: Observable<Mutation> = .just(.setRoleSkillsList(roleSkillsService.roleSkillsList))
      let setProfile: Observable<Mutation> = .just(.setProfile(userService.profile))
      
      return setAddressList
        .concat(setInterestList)
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
      
    case let .didTapSaveButton(parameter):
      var parameter = parameter
      
      let codes = interestService.interestList
        .enumerated()
        .map { offset, element in
          parameter.interestings.map { item -> String in
            if element.name == item {
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
    case let .setAddressList(addressList):
      newState.addressList = addressList
      
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
