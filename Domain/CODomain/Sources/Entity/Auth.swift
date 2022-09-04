//
//  Auth.swift
//  CODomain
//
//  Created by sean on 2022/09/04.
//

import Foundation

public enum AuthType: Int, CustomStringConvertible, CaseIterable {
  
  public var description: String {
    switch self {
    case .kakao:
      return "KAKAO"
    case .naver:
      return "NAVER"
    case .apple:
      return "APPLE"
    case .none:
      return ""
    }
  }
  
  case kakao = 0, naver, apple, none
}
