//
//  SignUpUseCaseImpl.swift
//  Sign
//
//  Created by sean on 2022/09/24.
//

import Foundation

import CODomain
import COExtensions
import COManager
import RxSwift

public final class SignUpUseCaseImpl: NSObject, SignUpUseCase {
  
  private let repository: SignUpRepository
  
  public init(repository: SignUpRepository) {
    self.repository = repository
    super.init()
  }
}

extension SignUpUseCaseImpl {
  public func getRegionList(query: String) -> Observable<[Region]> {
    return repository.requestSearchAddress(query: query)
      .flatMapLatest { address -> Observable<[Region]> in
        return .just(address.documents.map {
          Region(code: Int($0.address?.bCode ?? "") ?? 0, name: $0.address?.addressName ?? "")
        })
    }
  }
  
  public func signUp(parameter: SignUpParameter, accessToken: String) -> Observable<Profile> {
    return repository.requestSignUp(parameter: parameter, accessToken: accessToken)
  }
}
