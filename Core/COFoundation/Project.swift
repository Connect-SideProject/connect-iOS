import ProjectDescription
import ProjectDescriptionHelpers

let foundation = Project.feature(
  name: "COFoundation",
  products: [.framework(.dynamic)],
  dependencies: [
    .Project.Core.common,
    .Project.Core.manager,
    .Project.Core.extensions
  ]
)
