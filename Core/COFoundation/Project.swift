import ProjectDescription
import ProjectDescriptionHelpers

let foundation = Project.feature(
  name: "COFoundation",
  products: [.framework(.dynamic)],
  dependencies: [
    .project(target: "COCommon", path: .relativeToRoot("Core/COCommon")),
    .project(target: "COManager", path: .relativeToRoot("Core/COManager")),
    .project(target: "COExtensions", path: .relativeToRoot("Core/COExtensions"))

  ]
)
