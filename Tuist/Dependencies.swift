//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/06/02.
//

import ProjectDescription

/// 외부 dependencies 업데이트 및 반영을 위해서 'tuist fetch' 명령어 실행.
let dependencies = Dependencies(
  carthage: [
    .github(path: "layoutBox/FlexLayout", requirement: .upToNext("1.3.24"))
  ],
  swiftPackageManager: [
    .remote(
      url: "https://github.com/ReactiveX/RxSwift.git",
      requirement: .exact("6.0.0")
    ),
    .remote(
        url: "https://github.com/RxSwiftCommunity/RxDataSources",
        requirement: .upToNextMajor(from: "5.0.0")
    ),
    .remote(
      url: "https://github.com/ReactorKit/ReactorKit.git",
      requirement: .upToNextMajor(from: "3.0.0")
    ),
    .remote(
      url: "https://github.com/SnapKit/SnapKit.git",
      requirement: .upToNextMajor(from: "5.0.1")
    ),
    .remote(
        url: "https://github.com/layoutBox/PinLayout.git",
        requirement: .upToNextMajor(from: "1.10.3")
    ),
    .remote(
        url: "https://github.com/devxoul/Then",
        requirement: .upToNextMajor(from: "3.0.0")
    )
  ],
  platforms: [.iOS]
)
