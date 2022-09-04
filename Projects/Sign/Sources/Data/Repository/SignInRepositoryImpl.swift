//
//  SignInRepositoryImpl.swift
//  Sign
//
//  Created by sean on 2022/09/04.
//

import Foundation

import CODomain
import CONetwork
import RxSwift
import KakaoSDKUser

public final class SignInRepositoryImpl: SignInRepository {
  
  private let apiService: ApiService
  
  public init(apiService: ApiService = ApiManager.shared) {
    self.apiService = apiService
  }
}

extension SignInRepositoryImpl {
  
  public func requestAccessTokenWithKakaoTalk() -> Observable<String> {
    return UserApi.shared.rx.loginWithKakaoTalk()
      .asObservable()
      .flatMap { oauthToken -> Observable<String> in
        return .just(oauthToken.accessToken)
      }
  }
  
  public func requestAccessTokenWithKakaoAccount() -> Observable<String> {
    return UserApi.shared.rx.loginWithKakaoAccount()
      .asObservable()
      .flatMap { oauthToken -> Observable<String> in
        return .just(oauthToken.accessToken)
      }
  }
  
  public func requestProfile(authType: AuthType) -> Observable<CODomain.Profile> {
    return apiService.request(endPoint: .init(path: .signIn(authType)))
  }
}
