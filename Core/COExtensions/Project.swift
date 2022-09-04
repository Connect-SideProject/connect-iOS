import ProjectDescription
import ProjectDescriptionHelpers

let extensions = Project.feature(
  name: "COExtensions",
  products: [.framework],
  dependencies: [
    .external(name: "RxCocoa")
  ]
)
