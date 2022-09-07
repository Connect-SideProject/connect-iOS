import ProjectDescription
import ProjectDescriptionHelpers

let sign = Project.feature(
  name: "Sign",
  products: [.framework(.dynamic), .demoApp, .unitTests],
  infoExtension: [
    "LSApplicationQueriesSchemes": .array(
      [.string("kakaokompassauth"), .string("kakaolink"), .string("naversearchapp"), .string("naversearchthirdlogin")]
    )
  ],
  dependencies: [
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI")),
    .project(target: "COFoundation", path: .relativeToRoot("Core/COFoundation")),
    .project(target: "CONetwork", path: .relativeToRoot("Core/CONetwork")),
    .project(target: "CODomain", path: .relativeToRoot("Domain/CODomain")),
    .external(name: "KakaoSDKUser"),
    .external(name: "ReactorKit")
  ]
)
