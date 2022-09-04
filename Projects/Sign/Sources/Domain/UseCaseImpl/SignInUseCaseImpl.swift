//
//  SignInUseCaseImpl.swift
//  Sign
//
//  Created by sean on 2022/09/04.
//

import Foundation

import CODomain
import CONetwork
import COManager
import KakaoSDKUser
import RxSwift

public final class SignInUseCaseImpl: SignInUseCase {
  
  private let repository: SignInRepository
  private let userService: UserService
  
  public init(
    repository: SignInRepository,
    userService: UserService = UserManager.shared
  ) {
    self.repository = repository
    self.userService = userService
  }
}

public extension SignInUseCaseImpl {
  func signIn(authType: AuthType) -> Observable<CODomain.Profile> {
    switch authType {
    case .kakao:
      if UserApi.isKakaoTalkLoginAvailable() {
        return repository.requestAccessTokenWithKakaoTalk()
          .flatMap { [weak self] accessToken -> Observable<CODomain.Profile> in
            guard let self = self else { return .empty() }
            self.userService.update(accessToken: accessToken)
            return self.fetchProfile(authType: authType)
          }
      } else {
        return repository.requestAccessTokenWithKakaoAccount()
          .flatMap { [weak self] accessToken -> Observable<CODomain.Profile> in
            guard let self = self else { return .empty() }
            self.userService.update(accessToken: accessToken)
            return self.fetchProfile(authType: authType)
          }
      }
    default:
      return .empty()
    }
  }
  
  private func fetchProfile(authType: AuthType) -> Observable<CODomain.Profile> {
    return repository.requestProfile(authType: authType)
      .asObservable()
  }
}
