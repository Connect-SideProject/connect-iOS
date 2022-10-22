import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let profile = Project.feature(
  name: "Profile",
  products: [.framework(.static), .demoApp, .unitTests],
  infoExtension: [
    "NSCameraUsageDescription": .string("사용자 프로필 사진에 활용하기 위해서 접근권한이 필요합니다."),
    "NSPhotoLibraryUsageDescription": .string("사용자 프로필 사진에 활용하기 위해서 접근권한이 필요합니다.")
  ],
  dependencies: [
    .project(target: "COAuth", path: .relativeToRoot("Auth/COAuth")),
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI")),
    .project(target: "COFoundation", path: .relativeToRoot("Core/COFoundation")),
    .project(target: "CONetwork", path: .relativeToRoot("Core/CONetwork")),
    .project(target: "COThirdParty", path: .relativeToRoot("Core/COThirdParty")),
    .project(target: "CODomain", path: .relativeToRoot("Domain/CODomain"))
  ]
)
