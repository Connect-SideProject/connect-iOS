//
//  SignUpRepository.swift
//  Sign
//
//  Created by sean on 2022/09/24.
//

import Foundation

import CODomain
import KakaoSDKCommon
import RxSwift

public protocol SignUpRepository {
  func requestSearchAddress(query: String) -> Observable<KakaoMapAddresses>
  func requestSignUp(parameter: SignUpParameter, accessToken: String) -> Observable<Profile>
}
