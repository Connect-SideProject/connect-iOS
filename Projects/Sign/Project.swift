import ProjectDescription
import ProjectDescriptionHelpers

let sign = Project.feature(
  name: "Sign",
  products: [.framework],
  infoDict: [
    "LSApplicationQueriesSchemes": .array(
      ["kakaokompassauth", "kakaolink"]
    )
  ],
  dependencies: [
    .project(target: "COManager", path: .relativeToRoot("Core/COManager")),
    .project(target: "CONetwork", path: .relativeToRoot("Core/CONetwork")),
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI")),
    .external(name: "KakaoSDKUser"),
    .external(name: "ReactorKit")
  ]
)
