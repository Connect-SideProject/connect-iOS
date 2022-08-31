//
//  InfoPlist+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/08/31.
//

import ProjectDescription

// info.plist의 내용을 직접 지정
extension InfoPlist {
  
  static func base(name: String) -> [String: InfoPlist.Value] {
    return [
      "CFBundleName": .string(name),
      "CFBundleDisplayName": .string(name),
      "CFBundleIdentifier": .string("com.butterfree.\(name)"),
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
  
  public static func `default`(name: String) -> Self {
    return .extendingDefault(with: InfoPlist.base(name: name))
  }
  
  public static func custom(
    name: String,
    extentions: [String: InfoPlist.Value]
  ) -> Self {
    var dictionary = InfoPlist.base(name: name)
    
    extentions.keys.enumerated().forEach { offset, key in
      dictionary.updateValue(extentions[key]!, forKey: key)
    }

    return .extendingDefault(with: dictionary)
  }
}
