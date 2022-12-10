import ProjectDescription
import ProjectDescriptionHelpers

let domain = Project.feature(
  name: "CODomain",
  products: [.framework(.dynamic)],
  dependencies: [
    .Project.Core.extensions
  ]
)
