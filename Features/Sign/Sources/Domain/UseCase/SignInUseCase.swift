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
  func accessTokenFromThirdParty(authType: AuthType) -> Observable<String>
  func signIn(authType: AuthType, accessToken: String) -> Observable<Profile>
}
