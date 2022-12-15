import ProjectDescription
import ProjectDescriptionHelpers

let manager = Project.feature(
  name: "COManager",
  products: [.framework(.static)],
  dependencies: [
    .Project.Domain.domain,
    .Project.Core.extensions
  ]
)
