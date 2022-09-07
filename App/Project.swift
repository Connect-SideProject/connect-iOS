import ProjectDescription
import ProjectDescriptionHelpers

let app = Project.feature(
  name: "connect",
  products: [.app, .unitTests, .uiTests],
  infoExtension: [
    "LSApplicationQueriesSchemes": .array(
      [.string("naversearchapp"), .string("naversearchthirdlogin")]
    ),
    "CFBundleURLTypes": .array([
      .dictionary([
        "CFBundleURLSchemes": .array(["connectIT"]),
        "CFBundleURLName": .string("connectIT")
      ])
    ])
  ],
  dependencies: [
    .project(target: "Sign", path: .relativeToRoot("Features/Sign")),
    .project(target: "COExtensions", path: .relativeToRoot("Core/COExtensions")),
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI"))
    .xcframework(path: "Framework/NaverThirdPartyLogin.xcframework")
  ]
)
