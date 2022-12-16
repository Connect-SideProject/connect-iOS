import Foundation
import ProjectDescription
import ProjectDescriptionHelpers


let home = Project.feature(
    name: "Home",
    products: [.framework(.static), .demoApp, .unitTests],
    dependencies: [
        .project(target: "COAuth", path: .relativeToRoot("Auth/COAuth")),
        .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI")),
        .project(target: "COFoundation", path: .relativeToRoot("Core/COFoundation")),
        .project(target: "CONetwork", path: .relativeToRoot("Core/CONetwork")),
        .project(target: "COThirdParty", path: .relativeToRoot("Core/COThirdParty")),
        .project(target: "CODomain", path: .relativeToRoot("Domain/CODomain"))
    ]
)
