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
  
  // info.plist의 내용을 직접 지정
  public static func makeInfoPlist(
    name: String,
    bundleName: String = "com.sideproj"
  ) -> [String: InfoPlist.Value] {
    return [
      "CFBundleName": .string(name),
      "CFBundleDisplayName": .string(name),
      "CFBundleIdentifier": .string("\(bundleName).connect"),
      "CFBundleShortVersionString": .string("1.0"),
      "CFBundleVersion": .string("0"),
      "CFBuildVersion": .string("0"),
      "UILaunchStoryboardName": .string("Launch Screen"),
      "UISupportedInterfaceOrientations": .array([.string("UIInterfaceOrientationPortrait")]),
      "UIUserInterfaceStyle": .string("Light"),
      "UIApplicationSceneManifest": .dictionary([
        "UIApplicationSupportsMultipleScenes": .boolean(false),
        "UISceneConfigurations": .dictionary([
          "UIWindowSceneSessionRoleApplication": .array([
            .dictionary([
              "UISceneConfigurationName": .string("Default Configuration"),
              "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
            ])
          ])
        ])
      ])
    ]
  }
}

