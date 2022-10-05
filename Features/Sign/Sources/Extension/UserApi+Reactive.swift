//
//  UserApi+Reactive.swift
//  Sign
//
//  Created by sean on 2022/09/04.
//

import Foundation

import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

extension UserApi: ReactiveCompatible {}

extension Reactive where Base: UserApi {
  func loginWithKakaoTalk() -> Single<OAuthToken> {
    return Single<OAuthToken>.create { observer in

      UserApi.shared.loginWithKakaoTalk { oauthToken, error in
        if let oauthToken = oauthToken {
          observer(.success(oauthToken))
          return
        }
        
        if let error = error {
          observer(.failure(error))
        }
      }
      
      return Disposables.create()
    }
  }
  
  func loginWithKakaoAccount() -> Single<OAuthToken> {
    return Single<OAuthToken>.create { observer in

      UserApi.shared.loginWithKakaoAccount { oauthToken, error in
        if let oauthToken = oauthToken {
          observer(.success(oauthToken))
          return
        }
        
        if let error = error {
          observer(.failure(error))
        }
      }
      
      return Disposables.create()
    }
  }
}
