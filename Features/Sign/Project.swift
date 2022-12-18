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
    .Project.Auth.auth,
    .Project.UI.common,
    .Project.Core.foundation,
    .Project.Core.network,
    .Project.Core.thirdParty,
    .Project.Domain.domain
  ],
  externalDependencies: [
    .xcframework(path: .CocoaPods.Framework.naverLogin)
  ]
)
