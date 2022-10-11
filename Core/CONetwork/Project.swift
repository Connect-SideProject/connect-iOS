import ProjectDescription
import ProjectDescriptionHelpers

let network = Project.feature(
  name: "CONetwork",
  products: [.framework(.dynamic)],
  dependencies: [
    .project(target: "COAuth", path: .relativeToRoot("Auth/COAuth")),
    .project(target: "COFoundation", path: .relativeToRoot("Core/COFoundation"))
  ]
)
