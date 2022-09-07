//
//  SignInReactor.swift
//  Sign
//
//  Created by sean on 2022/09/03.
//

import Foundation

import CODomain
import ReactorKit
import NaverThirdPartyLogin
import RxRelay

public final class SignInReactor: NSObject, Reactor {
  public enum Action {
    case didTapSignInButton(type: AuthType)
    case accessToken(_ accessToken: String)
  }
  
  public enum Mutation {
    case setProfile(Profile?)
    case setError(URLError?)
  }
  
  public struct State {
    var profile: Profile?
    var error: URLError?
  }
  
  public var initialState: State = .init()
  
  private let loginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
  private let accessTokenRelay = PublishRelay<String>()
  
  private let errorHandler: (_ error: Error) -> Observable<Mutation> = { error in
    return .just(.setError(error.asURLError))
  }
  
  private let disposeBag = DisposeBag()
  
  private let useCase: SignInUseCase
  
  public init(useCase: SignInUseCase) {
    self.useCase = useCase
    super.init()
    
    loginConnection?.delegate = self
    
    accessTokenRelay
      .asObservable()
      .debug()
      .bind { [weak self] accessToken in
        self?.action.onNext(.accessToken(accessToken))
      }.disposed(by: disposeBag)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapSignInButton(let type):
      switch type {
      case .kakao:
        return useCase.signInWithKakao()
          .flatMap { profile -> Observable<Mutation> in
            return .just(.setProfile(profile))
          }
          .catch(errorHandler)
      case .naver:
        loginConnection?.requestThirdPartyLogin()
      default:
        return .empty()
      }
    case .accessToken(let accessToken):
      return useCase.signInWithNaver(accessToken: accessToken)
        .flatMap { profile -> Observable<Mutation> in
          return .just(.setProfile(profile))
        }
        .debug()
        .catch(errorHandler)
    }
    return .empty()
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setProfile(profile):
      newState.profile = profile
    case let .setError(error):
      newState.error = error
    }
    
    return newState
  }
}

extension SignInReactor: NaverThirdPartyLoginConnectionDelegate {
  public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
    
    if let accessToken = loginConnection?.accessToken {
      print("accessToken: \(accessToken)")
      accessTokenRelay.accept(accessToken)
    }
  }
  
  public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    print("oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
    
    if let accessToken = loginConnection?.accessToken {
      print("accessToken: \(accessToken)")
      accessTokenRelay.accept(accessToken)
    }
  }
  
  public func oauth20ConnectionDidFinishDeleteToken() {
    print("oauth20ConnectionDidFinishDeleteToken")
  }
  
  public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    print("oauth20Connection error: \(error)")
    accessTokenRelay.accept(oauthConnection.accessToken)
  }
}
