//
//  SignInRepository.swift
//  Sign
//
//  Created by sean on 2022/09/04.
//

import Foundation

import CODomain
import RxSwift

public protocol SignInRepository: AnyObject {
  func requestAccessTokenWithKakaoTalk() -> Observable<String>
  func requestAccessTokenWithKakaoAccount() -> Observable<String>
  func requestAccessTokenWithApple() -> Observable<String>
  func requestProfile(authType: AuthType) -> Observable<Profile>
}
