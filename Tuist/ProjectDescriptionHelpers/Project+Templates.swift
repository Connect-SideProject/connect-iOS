//
//  Project+Templates.swift
//  Manifests
//
//  Created by sean on 2022/08/07.
//

import ProjectDescription

extension Project {
  public static func feature(
    name: String,
    products: [Product],
    settings: Settings? = nil,
    infoPlist: InfoPlist = .default,
    dependencies: [TargetDependency] = []
  ) -> Project {
    
    var targets: [Target] = []
    
    if products.contains(.app) {
      let target: Target = .init(
        name: name,
        platform: .iOS,
        product: .app,
        bundleId: "com.sideproj.\(name)",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        infoPlist: infoPlist,
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: dependencies,
        settings: settings
      )
      targets.append(target)
    }
    
    if products.contains(.unitTests) {
      let target: Target = .init(
        name: "\(name)Tests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "com.sideproj.\(name)Tests",
        infoPlist: .default,
        sources: ["\(name)Tests/**"],
        resources: ["\(name)Tests/**"],
        dependencies: [.target(name: name)]
      )
      targets.append(target)
    }
    
    if products.contains(.uiTests) {
      let target: Target = .init(
        name: "\(name)UITests",
        platform: .iOS,
        product: .uiTests,
        bundleId: "com.sideproj.\(name)UITests",
        sources: "\(name)UITests/**",
        dependencies: [.target(name: name)]
      )
      targets.append(target)
    }
    
    return Project(
      name: name,
      targets: targets
    )
  }
  
  public static func makeSettings() -> Settings {
    
    let baseSetting: [String: SettingValue] = [:]
    
    return .settings(
      base: baseSetting,
      configurations: [
        .release(name: .release)
      ],
      defaultSettings: .recommended
    )
  }
}
