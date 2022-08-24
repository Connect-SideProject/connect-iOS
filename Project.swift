import ProjectDescription
import ProjectDescriptionHelpers

let app = Project.feature(
  name: "connect",
  products: [.app, .unitTests, .uiTests],
  infoPlist: .defaultApp,
  dependencies: [
    .external(name: "RxCocoa"),
    .external(name: "RxDataSources"),
    .external(name: "ReactorKit"),
    .external(name: "SnapKit"),
    .external(name: "FlexLayout"),
    .external(name: "PinLayout"),
    .external(name: "Then")
  ]
)
