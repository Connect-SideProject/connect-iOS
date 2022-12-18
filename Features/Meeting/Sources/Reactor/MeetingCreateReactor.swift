//
//  MeetingCreateReactor.swift
//  Meeting
//
//  Created by sean on 2022/11/11.
//

import Foundation

import ReactorKit
import RxCocoa
import COCommonUI
import CODomain
import COExtensions
import COManager
import CONetwork

public final class MeetingCreateReactor: Reactor, ErrorHandlerable {
  
  public enum Route {
    case close
    case bottomSheet(BottomSheetType)
  }
  
  public enum Action {
    /// 분야선택 버튼 터치
    case didTapInterestButton
    
    /// 역할 및 인원 버튼
    case didTapRoleAndPeopleButton
    
    /// 기간 버튼 터치
    case didTapDateButton
    
    /// 모임위치 버튼 터치
    case didTapRegionButton
    
    /// BottomSheet에서 선택된 요소.
    case didSelectedInterests([Int])
    case didSelectedAddress([Int])
    case didSelectedDateRange(DateRange)
    case didSelectedRoleAndCountItems([RoleAndCountItem])
    
    /// Alert 버튼 이벤트
    case didTapAlertButton(AlertButtonType)
    
    /// 모임만들기 버튼 터치
    case didTapCreateMeeting(CreateMeetingParameter)
  }
  
  public enum Mutation {
    
    case setSelectedInterests([Interest])
    case setSelectedRegion(Region)
    case setSelectedDateRange(DateRange)
    case setSelectedRoleAndCountItems([RoleAndCountItem])
    
    case setRoute(Route?)
    case setMessageType(MessageType?)
    case setError(COError?)
  }
  
  public struct State {
    var selectedInterests: [Interest] = []
    @Pulse var selectedRoleAndCountItems: [RoleAndCountItem]?
    @Pulse var selectedDateRange: DateRange?
    @Pulse var selectedRegion: Region?
    @Pulse var route: Route?
    @Pulse var messageType: MessageType?
    @Pulse var error: COError?
  }
  
  public var initialState: State = .init()
  
  public lazy var errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asCOError))
  }
  
  private let repository: MeetingCreateRepository
  private let userService: UserService
  private let interestService: InterestService
  private let addressService: AddressService
  private let roleSkillsService: RoleSkillsService
  
  public init(
    repository: MeetingCreateRepository,
    userService: UserService,
    interestService: InterestService,
    addressService: AddressService,
    roleSkillsService: RoleSkillsService
  ) {
    self.repository = repository
    self.userService = userService
    self.interestService = interestService
    self.addressService = addressService
    self.roleSkillsService = roleSkillsService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapInterestButton:
      var items: [BottomSheetItem] = []
      
      let interests = currentState.selectedInterests
      
      if interests.isEmpty {
        items = interestService.interestList.map {
          .init(value: $0.name)
        }
      } else {
        
        let selectedIndices = interestService.interestList
          .enumerated()
          .map { offset, element in
            return !interests.filter({ $0.name == element.name }).isEmpty ? offset : -1
          }
          .filter { $0 != -1 }
        
        items = interestService.interestList
          .enumerated()
          .map { offset, element in
            var item = BottomSheetItem(value: element.name)
            if !selectedIndices.filter({ $0 == offset }).isEmpty {
              item.update(isSelected: true)
            }
            return item
          }
      }
      
      return .just(.setRoute(.bottomSheet(.interest(
        selectionType: .multiple,
        items: items
      ))))
      
    case .didTapRoleAndPeopleButton:
      let roleList = roleSkillsService.roleSkillsList.map { $0.roleName }
      let item: BottomSheetRoleItem = .init(
        roles: roleList,
        items: [.init()]
      )
      
      return .just(.setRoute(.bottomSheet(.roleAndPeople(item))))
      
    case .didTapDateButton:
      return .just(.setRoute(.bottomSheet(.date)))
      
    case .didTapRegionButton:
      
      guard let region = currentState.selectedRegion else {
        let items: [BottomSheetItem] = addressService.addressList.map {
          .init(value: $0.법정동명)
        }
        return .just(.setRoute(.bottomSheet(.address(
          selectionType: .single,
          items: items
        ))))
      }
      
      let items: [BottomSheetItem] = addressService.addressList
        .map { element in
          var item = BottomSheetItem(value: element.법정동명)
          if element.법정동명 == region.name {
            item.update(isSelected: true)
          }
          return item
        }
      
      return .just(.setRoute(.bottomSheet(.address(
        selectionType: .single,
        items: items
      ))))
      
    case let .didSelectedInterests(indices):
      let interests = indices
        .map { interestService.interestList[$0] }
      
      return .just(.setSelectedInterests(interests))
      
    case let .didSelectedAddress(indices):
      guard let address = indices
        .map({ addressService.addressList[$0] }).first else {
        return .empty()
      }
      let region = Region(code: address.법정코드, name: address.법정동명)
      return .just(.setSelectedRegion(region))
      
    case let .didSelectedDateRange(dateRange):
      return .just(.setSelectedDateRange(dateRange))
      
    case let .didSelectedRoleAndCountItems(items):
      let items: [RoleAndCountItem] = roleSkillsService.roleSkillsList
        .map { element in
          return items
            .filter { $0.role == element.roleName }
            .map { return .init(id: $0.id, role: element.roleCode, count: $0.count) }
        }.flatMap { $0 }
      
      return .just(.setSelectedRoleAndCountItems(items))
      
    case .didTapAlertButton:
      return .just(.setRoute(.close))
      
    case let .didTapCreateMeeting(parameter):
      
      let interests = currentState.selectedInterests
      if interests.isEmpty {
        return .just(.setError(COError.message(nil, "관심분야를 최소 하나이상 선택 해주세요.")))
      }
      
      guard let roleAndCounts = currentState.selectedRoleAndCountItems else {
        return .just(.setError(COError.message(nil, "모집인원을 선택 해주세요.")))
      }
      
      guard let dateRange = currentState.selectedDateRange else {
        return .just(.setError(COError.message(nil, "프로젝트 기간을 설정 해주세요.")))
      }
      
      guard let region = currentState.selectedRegion else {
        return .just(.setError(COError.message(nil, "모임위치를 선택 해주세요.")))
      }
      var parameter = parameter
      parameter.updateInterests(interests)
      parameter.updateRoleAndCounts(roleAndCounts)
      parameter.updateDateRange(
        startDate: dateRange.start?.toFormattedString() ?? "",
        endDate: dateRange.end?.toFormattedString() ?? ""
      )
      parameter.updatePlace(region.description)
      
      return repository.requestCreateMeeting(parameter: parameter)
        .flatMap { (message: String) -> Observable<Mutation> in
          return .just(.setMessageType(.message(message)))
        }
        .catch(errorHandler)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setSelectedInterests(interests):
      newState.selectedInterests = interests
    case let .setSelectedRegion(region):
      newState.selectedRegion = region
    case let .setSelectedDateRange(dateRange):
      newState.selectedDateRange = dateRange
    case let .setSelectedRoleAndCountItems(items):
      newState.selectedRoleAndCountItems = items
    case let .setRoute(route):
      newState.route = route
    case let .setMessageType(messageType):
      newState.messageType = messageType
    case let .setError(error):
      newState.error = error
    }
    return newState
  }
}
