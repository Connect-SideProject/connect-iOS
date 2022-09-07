//
//  SignInUseCase.swift
//  SignApp
//
//  Created by sean on 2022/09/04.
//

import Foundation

import CODomain
import RxSwift

public protocol SignInUseCase {
  func signInWithKakao() -> Observable<Profile>
  func signInWithNaver(accessToken: String) -> Observable<Profile>
  func signInWithApple() -> Observable<Profile>
}
