import ProjectDescription
import ProjectDescriptionHelpers

let common = Project.feature(
  name: "COCommon",
  products: [.framework(.static)],
  dependencies: []
)
