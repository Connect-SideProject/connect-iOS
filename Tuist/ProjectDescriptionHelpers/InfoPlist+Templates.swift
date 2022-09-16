//
//  InfoPlist+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/08/31.
//

import ProjectDescription

// info.plist의 내용을 직접 지정
extension InfoPlist {
  
  static func app(name: String) -> [String: InfoPlist.Value] {
    return [
      "CFBundleName": .string(name),
      "CFBundleDisplayName": .string(name),
      "CFBundleIdentifier": .string("com.sideproj.\(name)"),
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
      ]),
      "NSAppTransportSecurity": .dictionary([
        "NSAllowsArbitraryLoads": .boolean(true),
        "NSExceptionDomains": .dictionary([
          "contpass.site": .dictionary([
            "NSIncludesSubdomains": .boolean(true),
            "NSTemporaryExceptionAllowsInsecureHTTPLoads": .boolean(true),
            "NSExceptionRequiresForwardSecrecy": .boolean(false),
            "NSTemporaryExceptionMinimumTLSVersion": .string("TLSv1.2")
          ])
        ])
      ])
    ]
  }
  
  public static func base(name: String) -> Self {
    return .extendingDefault(with: InfoPlist.app(name: name))
  }
  
  public static func custom(
    name: String,
    extentions: [String: InfoPlist.Value]
  ) -> Self {
    var dictionary = InfoPlist.app(name: name)
    
    extentions.keys.enumerated().forEach { offset, key in
      dictionary.updateValue(extentions[key]!, forKey: key)
    }

    return .extendingDefault(with: dictionary)
  }
}
