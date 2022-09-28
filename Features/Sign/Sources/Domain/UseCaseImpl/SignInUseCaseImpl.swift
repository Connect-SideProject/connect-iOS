//
//  SignInUseCaseImpl.swift
//  Sign
//
//  Created by sean on 2022/09/04.
//

import AuthenticationServices
import Foundation

import CODomain
import COExtensions
import COManager
import KakaoSDKUser
import NaverThirdPartyLogin
import RxSwift

public final class SignInUseCaseImpl: NSObject, SignInUseCase {
  
  private let loginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
  private let accessTokenSubject = PublishSubject<String>()
  private let authorizationCodeSubject = PublishSubject<String>()
  
  private let isStub: Bool
  
  private let repository: SignInRepository
  private let userService: UserService
  
  public init(
    repository: SignInRepository,
    userService: UserService = UserManager.shared
  ) {
    self.repository = repository
    self.userService = userService
    self.isStub = (userService is UserManagerStub)
    super.init()
        
    loginConnection?.delegate = self
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
            return self.combine(accessToken, authType: .kakao)
          }
      } else {
        return repository.requestAccessTokenWithKakaoAccount()
          .debug()
          .flatMap { [weak self] accessToken -> Observable<CODomain.Profile> in
            guard let self = self else { return .empty() }
            return self.combine(accessToken, authType: .kakao)
          }
      }
    case .naver:
      
      if isStub {
        return combine("accessToken", authType: authType)
      }
      
      loginConnection?.requestThirdPartyLogin()
      
      return accessTokenSubject
        .asObservable()
        .flatMap { [weak self] accessToken -> Observable<CODomain.Profile> in
          guard let self = self else { return .empty() }
          return self.combine(accessToken, authType: authType)
        }.debug()
      
    case .apple:
      
      if isStub {
        return combine("accessToken", authType: authType)
      }
      
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
      
      return authorizationCodeSubject
        .asObservable()
        .flatMap { [weak self] authorizationCode -> Observable<CODomain.Profile> in
          guard let self = self else { return .empty() }
          return self.combine(authorizationCode, authType: authType)
        }.debug()
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

extension SignInUseCaseImpl: NaverThirdPartyLoginConnectionDelegate {
  public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
    
    if let accessToken = loginConnection?.accessToken {
      print("accessToken: \(accessToken)")
      accessTokenSubject.onNext(accessToken)
    } else {
      print("accessToken is Nil!")
    }
  }
  
  public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    print("oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
    
    if let accessToken = loginConnection?.accessToken {
      print("accessToken: \(accessToken)")
      accessTokenSubject.onNext(accessToken)
    } else {
      print("accessToken is Nil!")
    }
  }
  
  public func oauth20ConnectionDidFinishDeleteToken() {
    print("oauth20ConnectionDidFinishDeleteToken")
  }
  
  public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    print("oauth20Connection error: \(String(describing: error))")
    accessTokenSubject.onNext(oauthConnection.accessToken)
  }
}

extension SignInUseCaseImpl: ASAuthorizationControllerDelegate {
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      if let identityToken = appleIDCredential.identityToken,
         let token = String(data: identityToken, encoding: .utf8) {
        authorizationCodeSubject.onNext(token)
      }
    default:
      break
    }
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("authorizationController error: \(error)")
  }
}

extension SignInUseCaseImpl: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return UIApplication.keyWindow ?? ASPresentationAnchor()
  }
}
