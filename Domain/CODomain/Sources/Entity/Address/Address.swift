//
//  Address.swift
//  CODomain
//
//  Created by sean on 2022/10/30.
//

import Foundation

public struct 법정주소: Decodable {
  public let 법정동명: String
  public let 법정코드: Int
  
  public init(법정동명: String, 법정코드: Int) {
    self.법정동명 = 법정동명
    self.법정코드 = 법정코드
  }
}
