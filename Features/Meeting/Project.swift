import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let meeting = Project.feature(
  name: "Meeting",
  products: [.framework(.static), .demoApp, .unitTests],
  dependencies: [
    .Project.Auth.auth,
    .Project.UI.common,
    .Project.Core.foundation,
    .Project.Core.network,
    .Project.Core.thirdParty,
    .Project.Domain.domain
  ]
)
