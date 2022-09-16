import ProjectDescription
import ProjectDescriptionHelpers

let manager = Project.feature(
  name: "COManager",
  products: [.framework(.static)],
  dependencies: [
    .project(target: "COExtensions", path: .relativeToRoot("Core/COExtensions"))
  ]
)
