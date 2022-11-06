//
//  SessionManager.swift
//  CONetwork
//
//  Created by sean on 2022/10/21.
//

import Foundation

import RxSwift
import CODomain
import COManager

final class SessionManager {
  
  static let shared: SessionManager = SessionManager()
  
  private let disposeBag = DisposeBag()
  
  private let apiService: ApiService
  private let userService: UserService
  
  private init(
    apiService: ApiService = ApiManager.shared,
    userService: UserService = UserManager.shared
  ) {
    self.apiService = apiService
    self.userService = userService
  }
  
  func update(headers: [AnyHashable : Any]) {
    
    let accessToken = headers["access-token"] as? String ?? ""
    let refreshToken = headers["refresh-token"] as? String ?? ""
    
    let tokens: Tokens = .init(
      access: accessToken,
      refresh: refreshToken
    )
    userService.update(tokens: tokens, profile: nil)
  }
  
  func process(errorCode: String, handler: () -> Void) {
    
    switch errorCode {
    case COError.expiredAccessToken:
      routeToSignIn()
      handler()
    case COError.expiredRefreshToken:
      requestRefreshToken()
    default:
      break
    }
  }
  
  func requestRefreshToken() {
    
    let _ = apiService.request(
      endPoint: .init(path: .refreshToken)
    ).bind { (data: EmptyResponse) in
      
    }.disposed(by: disposeBag)
  }
  
  func routeToSignIn() {
    
    userService.remove()
  }
}
