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
    .Project.Auth.auth,
    .Project.UI.common,
    .Project.Core.foundation,
    .Project.Core.network,
    .Project.Core.thirdParty,
    .Project.Domain.domain
  ]
)
