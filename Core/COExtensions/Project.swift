import ProjectDescription
import ProjectDescriptionHelpers

let extensions = Project.feature(
  name: "COExtensions",
  products: [.framework(.dynamic)],
  dependencies: [
    .external(name: "RxCocoa")
  ]
)
