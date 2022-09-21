import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let excludedFramework = ProcessInfo.processInfo.environment["TUIST_EXCLUEDED_FRAMEWORK"]
let isExcludedFramework = (excludedFramework == "TRUE")

let app = Project.feature(
  name: "App",
  bundleId: "com.sideproj.connect",
  products: [.app, .unitTests, .uiTests],
  isExcludedFramework: isExcludedFramework,
  infoExtension: [
    "LSApplicationQueriesSchemes": .array(
      [.string("kakaokompassauth"), .string("naversearchapp"), .string("naversearchthirdlogin")]
    ),
    "CFBundleURLTypes": .array([
      .dictionary([
        "CFBundleURLSchemes": .array(["connectIT"]),
        "CFBundleURLName": .string("connectIT")
      ]),
      .dictionary([
        "CFBundleURLSchemes": .array(["kakaoee72a7c08c0e36ae98010b8d02f646cf"])
      ])
    ]),
    "NMFClientId": .string("y5sse5c8he"),
    "NSLocationAlwaysAndWhenInUseUsageDescription": .string("사용자의 위치를 가져옵니다."),
    "NSLocationWhenInUseUsageDescription": .string("사용자의 위치를 가져옵니다."),
    "NSLocationAlwaysUsageDescription": .string("사용자의 위치를 가져옵니다.")
  ],
  dependencies: [
    .project(target: "Sign", path: .relativeToRoot("Features/Sign")),
    .project(target: "COFoundation", path: .relativeToRoot("Core/COFoundation")),
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI")),
    .project(target: "COThirdParty", path: .relativeToRoot("Core/COThirdParty")),
  ],
  externalDependencies: [
    .xcframework(path: .CocoaPods.Framework.naverLogin),
    .xcframework(path: .CocoaPods.Framework.naverMaps)
  ]
)
