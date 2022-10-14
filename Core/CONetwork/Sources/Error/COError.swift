//
//  COError.swift
//  CONetwork
//
//  Created by sean on 2022/10/13.
//

import Foundation

public enum COError: Error, Equatable {
  
  /// 로그인 진행시 회원가입 요청.
  case needSignUp
  
  /// 상태코드.
  case statusCode(Int)
  
  /// 응답 데이터 없음.
  case responseDataIsNil
  
  /// 포맷 데이터 없음.
  case dataNotAllowed
  
  /// Json 데이터 디코딩 불가.
  case cannotDecodeJsonData
  
  /// 에러 메세지. (에러코드, 메세지)
  case message(String?, String)
  
  /// 알수없는 에러.
  case unknown
}

extension Error {
  public var asCOError: COError? {
    return self as? COError
  }
}
