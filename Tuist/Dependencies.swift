//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/06/02.
//

import ProjectDescription

/// 외부 dependencies 업데이트 및 반영을 위해서 'tuist fetch' 명령어 실행.
let dependencies = Dependencies(
  swiftPackageManager: [
    .remote(
      url: "https://github.com/ReactorKit/ReactorKit.git",
      requirement: .upToNextMajor(from: "3.0.0")
    ),
    .remote(
      url: "https://github.com/ReactiveX/RxSwift.git",
      requirement: .exact("6.0.0")
    ),
    .remote(
      url: "https://github.com/SnapKit/SnapKit.git",
      requirement: .upToNextMajor(from: "5.0.1")
    ),
    .remote(
      url: "https://github.com/layoutBox/FlexLayout.git",
      requirement: .upToNextMajor(from: "1.3.18")
    )
  ],
  platforms: [.iOS]
)
