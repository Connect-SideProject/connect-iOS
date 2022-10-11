import ProjectDescription
import ProjectDescriptionHelpers

let thirdParty = Project.feature(
  name: "COThirdParty",
  products: [.framework(.dynamic)],
  dependencies: [
    .external(name: "KakaoSDKUser"),
    .external(name: "RxCocoa"),
    .external(name: "ReactorKit"),
    .external(name: "FloatingPanel")
  ]
)
