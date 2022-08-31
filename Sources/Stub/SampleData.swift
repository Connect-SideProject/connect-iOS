//
//  SampleData.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

struct SampleData {
  
  let path: PathType
//  let userName: String
//  let jobGroup: JobGroup
//  let location: String
//  let attentions: String
//  let portfolioURL: String
//  let career: String
//  let skills: [String]
//  let isPushOn: Bool
//  let isLocationExpose: Bool
  func create() -> Data {
    switch path {
    case .userProfile:
      let profile: Profile = .init(
        profileURL: "https://avatars.githubusercontent.com/u/24970070",
        userName: "시원",
        jobGroup: .developer,
        location: "경기 시흥시",
        attentions: "iOS, Fontend",
        portfolioURL: "https://portfolio.com",
        career: "주니어",
        skills: ["Swift", "RxSwift"],
        isPushOn: true,
        isLocationExpose: true
      )
      return makeData(parameter: profile.asDictionary()!)
    case .updateProfile(let profile):
      return makeData(parameter: profile.asDictionary()!)
    }
  }
}

extension SampleData {
  func makeData(parameter: [String: Any]) -> Data {
    return try! JSONSerialization.data(withJSONObject: parameter)
  }
  
  func makeData(parameters: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: parameters)
  }
}
