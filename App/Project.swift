import ProjectDescription
import ProjectDescriptionHelpers

let app = Project.feature(
  name: "connect",
  products: [.app, .unitTests, .uiTests],
  dependencies: [
    .project(target: "Sign", path: .relativeToRoot("Features/Sign")),
    .project(target: "COExtensions", path: .relativeToRoot("Core/COExtensions")),
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI"))
  ]
)
