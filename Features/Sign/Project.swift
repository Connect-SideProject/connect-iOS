import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let excludedFramework = ProcessInfo.processInfo.environment["TUIST_EXCLUEDED_FRAMEWORK"]
let isExcludedFramework = (excludedFramework == "TRUE")

let sign = Project.feature(
  name: "Sign",
  products: [.framework(.static), .demoApp, .unitTests],
  isExcludedFramework: isExcludedFramework,
  infoExtension: [
    "LSApplicationQueriesSchemes": .array(
      [.string("kakaokompassauth"), .string("kakaolink"), .string("naversearchapp"), .string("naversearchthirdlogin")]
    )
  ],
  dependencies: [
    .project(target: "COAuth", path: .relativeToRoot("Auth/COAuth")),
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI")),
    .project(target: "COFoundation", path: .relativeToRoot("Core/COFoundation")),
    .project(target: "CONetwork", path: .relativeToRoot("Core/CONetwork")),
    .project(target: "COThirdParty", path: .relativeToRoot("Core/COThirdParty")),
    .project(target: "CODomain", path: .relativeToRoot("Domain/CODomain"))
  ],
  externalDependencies: [
    .xcframework(path: .CocoaPods.Framework.naverLogin)
  ]
)