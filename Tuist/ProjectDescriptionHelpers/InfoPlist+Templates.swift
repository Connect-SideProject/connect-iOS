//
//  InfoPlist+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/08/23.
//

import ProjectDescription

extension InfoPlist {
  
  // info.plist의 내용을 직접 지정
  public static var defaultApp: Self {
    
    let dictionary: [String: Value] = [
      "CFBundleName": .string("connect"),
      "CFBundleDisplayName": .string("connect"),
      "CFBundleIdentifier": .string("com.sideproj.connect"),
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
    
    return .extendingDefault(with: dictionary)
  }
}
