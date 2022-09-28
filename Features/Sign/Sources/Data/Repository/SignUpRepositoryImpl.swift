//
//  SignUpRepositoryImpl.swift
//  Sign
//
//  Created by sean on 2022/09/24.
//

import Foundation

import CODomain
import CONetwork
import RxSwift

public final class SignUpRepositoryImpl: SignUpRepository {

  private let apiService: ApiService
  
  public init(apiService: ApiService = ApiManager.shared) {
    self.apiService = apiService
  }
}

extension SignUpRepositoryImpl {
  
  public func requestSearchAddress(query: String) -> Observable<CODomain.KakaoMapAddresses> {
    return apiService.requestOutBound(endPoint: .init(path: .serchPlace(query)))
  }
  
  public func requestSignUp(parameter: SignUpParameter) -> Observable<CODomain.Profile> {
    return apiService.request(endPoint: .init(path: .signUp(parameter)))
  }
}

