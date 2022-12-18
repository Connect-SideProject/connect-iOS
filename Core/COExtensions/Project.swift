import ProjectDescription
import ProjectDescriptionHelpers

let extensions = Project.feature(
  name: "COExtensions",
  products: [.framework(.static)],
  dependencies: [
    .Project.Core.thirdParty
  ]
)
