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
    "NSLocationAlwaysUsageDescription": .string("사용자의 위치를 가져옵니다."),
    "NSCameraUsageDescription": .string("사용자 프로필 사진에 활용하기 위해서 접근권한이 필요합니다."),
    "NSPhotoLibraryUsageDescription": .string("사용자 프로필 사진에 활용하기 위해서 접근권한이 필요합니다.")
  ],
  dependencies: [
    .Project.Core.foundation,
    .Project.UI.common,
    .Project.Core.thirdParty
  ],
  externalDependencies: [
    .Project.Features.features,
    .xcframework(path: .CocoaPods.Framework.naverLogin),
    .xcframework(path: .CocoaPods.Framework.naverMaps)
  ]
)
