import ProjectDescription
import ProjectDescriptionHelpers

let extensions = Project.feature(
  name: "COExtensions",
  products: [.framework(.static)],
  dependencies: [
    .project(target: "COThirdParty", path: .relativeToRoot("Core/COThirdParty"))
  ]
)
