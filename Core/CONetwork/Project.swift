import ProjectDescription
import ProjectDescriptionHelpers

let network = Project.feature(
  name: "CONetwork",
  products: [.framework(.dynamic)],
  dependencies: [
    .Project.Auth.auth,
    .Project.Core.foundation
  ]
)
