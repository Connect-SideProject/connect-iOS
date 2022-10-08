import ProjectDescription
import ProjectDescriptionHelpers

let manager = Project.feature(
  name: "COManager",
  products: [.framework(.static)],
  dependencies: [
    .project(target: "CODomain", path: .relativeToRoot("Domain/CODomain")),
    .project(target: "COExtensions", path: .relativeToRoot("Core/COExtensions"))
  ]
)
