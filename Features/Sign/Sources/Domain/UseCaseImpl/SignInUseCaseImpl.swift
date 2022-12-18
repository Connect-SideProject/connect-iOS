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
  private let identityTokenSubject = PublishSubject<String>()
  
  private let isStub: Bool = false
  
  private let repository: SignInRepository
  
  public init(repository: SignInRepository) {
    self.repository = repository
    super.init()
    
    loginConnection?.delegate = self
  }
}

extension SignInUseCaseImpl {
  public func accessTokenFromThirdParty(authType: AuthType) -> Observable<String> {
    switch authType {
    case .kakao:
      
      if isStub {
        return .just("accessToken")
      }
      
      if UserApi.isKakaoTalkLoginAvailable() {
        return repository
          .requestAccessTokenWithKakaoTalk()
          .map { $0 }
      } else {
        return repository.requestAccessTokenWithKakaoAccount()
          .map { $0 }
      }
    case .naver:
      
      if isStub {
        return .just("accessToken")
      }
      
      loginConnection?.requestThirdPartyLogin()
      
      return accessTokenSubject
        .asObservable()
        .map { $0 }
      
    case .apple:
      
      if isStub {
        return .just("accessToken")
      }
      
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
      
      return identityTokenSubject
        .asObservable()
        .map { $0 }
    }
  }
  
  public func signIn(authType: AuthType, accessToken: String) -> Observable<CODomain.Profile> {
    return repository.requestProfile(authType: authType, accessToken: accessToken).asObservable()
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
        identityTokenSubject.onNext(token)
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
