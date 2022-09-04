import ProjectDescription
import ProjectDescriptionHelpers

let manager = Project.feature(
  name: "COManager",
  products: [.staticFramework],
  dependencies: [
    .project(target: "COExtensions", path: .relativeToRoot("Core/COExtensions"))
  ]
)
