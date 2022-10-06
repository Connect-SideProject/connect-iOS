import ProjectDescription
import ProjectDescriptionHelpers

let commonUI = Project.feature(
  name: "COCommonUI",
  products: [.framework(.dynamic)],
  dependencies: [
    .project(target: "COFoundation", path: .relativeToRoot("Core/COFoundation")),
    .external(name: "SnapKit"),
    .external(name: "FlexLayout"),
    .external(name: "PinLayout"),
    .external(name: "Then")
  ]
)
