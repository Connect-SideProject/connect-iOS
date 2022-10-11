import ProjectDescription
import ProjectDescriptionHelpers

let thirdParty = Project.feature(
  name: "COThirdParty",
  products: [.framework(.dynamic)],
  dependencies: [
    .external(name: "KakaoSDKUser"),
    .external(name: "RxCocoa"),
    .external(name: "RxDataSources"),
    .external(name: "ReactorKit"),
    .external(name: "FloatingPanel")
  ]
)
