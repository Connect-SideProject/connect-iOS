//
//  Path+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/09/19.
//

import ProjectDescription

public extension Path {
  struct SPM {}
  struct CocoaPods {
    public struct Framework { }
  }
}

extension Path.CocoaPods.Framework {
  public static let naverMaps: Path = .relativeToRoot("Pods/NMapsMap/framework/NMapsMap.xcframework")
  public static let naverLogin: Path = .relativeToRoot("Pods/naveridlogin-sdk-ios/NaverThirdPartyLogin.xcframework")
}
