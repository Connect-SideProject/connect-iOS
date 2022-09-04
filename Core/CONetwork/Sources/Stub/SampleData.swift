//
//  SampleData.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import CODomain
import COExtensions

public struct SampleData {
  
  let path: Path
  
  public func create() -> Data {
    switch path {
    case .userProfile:
      let profile: Profile = .init(
        profileURL: "https://avatars.githubusercontent.com/u/24970070",
        nickname: "시원",
        roles: [.developer],
        region: .init(state: "SEO", city: "SUNGNAM"),
        interestings: ["HEALTH"],
        portfolioURL: "https://portfolio.com",
        career: "JUNIOR",
        skills: ["Swift", "RxSwift"],
        isPushOn: true,
        isLocationExpose: true
      )
      return makeData(parameter: profile.asDictionary()!)
    case .updateProfile(let profile):
      return makeData(parameter: profile.asDictionary()!)
    default:
      return Data()
    }
  }
}

public extension SampleData {
  func makeData(parameter: [String: Any]) -> Data {
    return try! JSONSerialization.data(withJSONObject: parameter)
  }
  
  func makeData(parameters: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: parameters)
  }
}
