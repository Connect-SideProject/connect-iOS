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

extension SignInUseCaseImpl {
  public func signIn(authType: AuthType) -> Observable<CODomain.Profile> {
    switch authType {
    case .kakao:
      if UserApi.isKakaoTalkLoginAvailable() {
        return repository.requestAccessTokenWithKakaoTalk()
          .flatMap { [weak self] accessToken -> Observable<CODomain.Profile> in
            guard let self = self else { return .empty() }
            return self.combine(accessToken, authType: authType)
          }
      } else {
        return repository.requestAccessTokenWithKakaoAccount()
          .debug()
          .flatMap { [weak self] accessToken -> Observable<CODomain.Profile> in
            guard let self = self else { return .empty() }
            return self.combine(accessToken, authType: authType)
          }
      }
    case .naver:
      return repository.requestAccessTokenWithNaver()
        .flatMap { [weak self] accessToken -> Observable<CODomain.Profile> in
          guard let self = self else { return .empty() }
          return self.combine(accessToken, authType: authType)
        }
    case .apple:
      return repository.requestAccessTokenWithApple()
        .flatMap { [weak self] accessToken -> Observable<CODomain.Profile> in
          guard let self = self else { return .empty() }
          return self.combine(accessToken, authType: authType)
        }
    default:
      return .empty()
    }
  }
  
  private func combine(_ accessToken: String, authType: AuthType) -> Observable<CODomain.Profile> {
    updateAccessToken(accessToken)
    return fetchProfile(authType: authType)
  }
  
  private func updateAccessToken(_ accessToken: String) {
    userService.update(accessToken: accessToken)
  }
  
  private func fetchProfile(authType: AuthType) -> Observable<CODomain.Profile> {
    return repository.requestProfile(authType: authType)
      .asObservable()
  }
}
