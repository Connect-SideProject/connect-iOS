////
////  SampleData.swift
////  connect
////
////  Created by sean on 2022/07/23.
////  Copyright © 2022 sideproj. All rights reserved.
////
//
//import Foundation
//
//struct SampleData {
//
//  let path: PathType
//
//  func create() -> Data {
//    switch path {
//    case .userProfile:
//      let profile: Profile = .init(
//        profileURL: "https://avatars.githubusercontent.com/u/24970070",
//        userName: "시원",
//        jobGroup: .developer
//      )
//      return makeData(parameter: profile.asDictionary()!)
//    case .updateProfile(let profile):
//      return makeData(parameter: profile.asDictionary()!)
//    }
//  }
//}
//
//extension SampleData {
//  func makeData(parameter: [String: Any]) -> Data {
//    return try! JSONSerialization.data(withJSONObject: parameter)
//  }
//
//  func makeData(parameters: [[String: Any]]) -> Data {
//    return try! JSONSerialization.data(withJSONObject: parameters)
//  }
//}
