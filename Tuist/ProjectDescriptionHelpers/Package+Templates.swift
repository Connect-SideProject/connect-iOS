//
//  Package+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/11/20.
//

import ProjectDescription

extension Package {
  public struct ThirdParty {
    public struct UI {}
  }
}

extension Package.ThirdParty.UI {
  public static let fsCalendar: Package = .package(
    url: "https://github.com/WenchaoD/FSCalendar.git", .upToNextMajor(from: "2.8.3")
  )
}
