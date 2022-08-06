import ProjectDescription
import ProjectDescriptionHelpers

let app = Project.feature(
  name: "connect",
  products: [.app, .unitTests, .uiTests],
  dependencies: [
    .external(name: "ReactorKit"),
    .external(name: "RxCocoa"),
    .external(name: "SnapKit"),
    .external(name: "FlexLayout"),
    .external(name: "PinLayout")
  ]
)
