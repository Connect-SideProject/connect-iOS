//
//  SignUpUseCae.swift
//  Sign
//
//  Created by sean on 2022/09/24.
//

import Foundation

import CODomain
import RxSwift

public protocol SignUpUseCase {
  func getRegionList(query: String) -> Observable<[Region]>
  func signUp(parameter: SignUpParameter) -> Observable<Profile>
}
