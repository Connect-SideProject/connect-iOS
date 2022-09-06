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
  private let isStub: Bool
  
  public init(apiService: ApiService = ApiManager.shared) {
    self.apiService = apiService
    self.isStub = (apiService is ApiManaerStub)
  }
}

extension SignInRepositoryImpl {
  
  public func requestAccessTokenWithKakaoTalk() -> Observable<String> {
    
    if isStub {
      return .just("accessToken")
    }
    
    return UserApi.shared.rx.loginWithKakaoTalk()
      .asObservable()
      .flatMap { oauthToken -> Observable<String> in
        return .just(oauthToken.accessToken)
      }
  }
  
  public func requestAccessTokenWithKakaoAccount() -> Observable<String> {
    
    if isStub {
      return .just("accessToken")
    }
    
    return UserApi.shared.rx.loginWithKakaoAccount()
      .asObservable()
      .flatMap { oauthToken -> Observable<String> in
        return .just(oauthToken.accessToken)
      }
  }
  
  public func requestAccessTokenWithNaver() -> Observable<String> {
    return .just("accessToken")
  }
  
  public func requestAccessTokenWithApple() -> Observable<String> {
    return .just("accessToken")
  }
  
  public func requestProfile(authType: AuthType) -> Observable<CODomain.Profile> {
    return apiService.request(endPoint: .init(path: .signIn(authType)))
  }
}
