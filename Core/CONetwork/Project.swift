import ProjectDescription
import ProjectDescriptionHelpers

let network = Project.feature(
  name: "CONetwork",
  products: [.framework(.dynamic)],
  dependencies: [
    .project(target: "COFoundation", path: .relativeToRoot("Core/COFoundation"))
  ]
)
