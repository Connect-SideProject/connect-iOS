import ProjectDescription
import ProjectDescriptionHelpers

let sign = Project.feature(
  name: "Sign",
  products: [.framework(.dynamic), .demoApp, .unitTests],
  infoExtension: [
    "LSApplicationQueriesSchemes": .array(
      ["kakaokompassauth", "kakaolink"]
    )
  ],
  dependencies: [
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI")),
    .project(target: "COCommon", path: .relativeToRoot("Core/COCommon")),
    .project(target: "COManager", path: .relativeToRoot("Core/COManager")),
    .project(target: "CONetwork", path: .relativeToRoot("Core/CONetwork")),
    .external(name: "KakaoSDKUser"),
    .external(name: "ReactorKit"),
  ]
)
