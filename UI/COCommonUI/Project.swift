import ProjectDescription
import ProjectDescriptionHelpers

let commonUI = Project.feature(
  name: "COCommonUI",
  products: [.framework(.dynamic)],
  dependencies: [
    .Project.Core.foundation,
    .Project.Core.thirdParty
  ]
)
