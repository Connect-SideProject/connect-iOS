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
    
    /// 기간 버튼 터치
    case didTapDateButton
    
    /// 모임위치 버튼 터치
    case didTapLocationButton
  }
  
  public enum Mutation {
    case setRoute(Route?)
    case setMessage(MessageType?)
  }
  
  public struct State {
    var selectedInterestIndex: Int?
    var selectedDateIndex: Int?
    var selectedLocationIndex: Int?
    @Pulse var route: Route?
    var message: MessageType?
  }
  
  public var initialState: State = .init()
  
  public lazy var errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setMessage(.message(error.localizedDescription)))
  }
  
  private let apiService: ApiService
  private let userService: UserService
  private let interestService: InterestService
  private let addressService: AddressService
  
  public init(
    apiService: ApiService,
    userService: UserService,
    interestService: InterestService,
    addressService: AddressService
  ) {
    self.apiService = apiService
    self.userService = userService
    self.interestService = interestService
    self.addressService = addressService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapInterestButton:
      let interestList: [BottomSheetItem] = interestService.interestList.map {
        .init(value: $0.name)
      }
      return .just(.setRoute(.bottomSheet(.interest(interestList))))
      
    case .didTapDateButton:
      return .just(.setRoute(.bottomSheet(.date)))
      
    case .didTapLocationButton:
      let addressList: [BottomSheetItem] = addressService.addressList.map {
        .init(value: $0.법정동명)
      }
      return .just(.setRoute(.bottomSheet(.address(addressList))))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setRoute(route):
      newState.route = route
    case let .setMessage(message):
      newState.message = message
    }
    
    return newState
  }
}
