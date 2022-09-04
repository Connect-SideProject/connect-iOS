import ProjectDescription
import ProjectDescriptionHelpers

let app = Project.feature(
  name: "connect",
  products: [.app, .unitTests, .uiTests],
  dependencies: [
    .project(target: "Sign", path: .relativeToRoot("Projects/Sign")),
    .project(target: "COExtensions", path: .relativeToRoot("Core/COExtensions")),
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI"))
  ]
)
