import ProjectDescription
import ProjectDescriptionHelpers

let network = Project.feature(
  name: "CONetwork",
  products: [.framework(.dynamic)],
  dependencies: [
    .project(target: "CODomain", path: .relativeToRoot("Domain/CODomain")),
    .project(target: "COExtensions", path: .relativeToRoot("Core/COExtensions"))
  ]
)
