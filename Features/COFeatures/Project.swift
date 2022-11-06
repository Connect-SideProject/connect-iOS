//
//  COFeatures.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/10/06.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let features = Project.feature(
  name: "COFeatures",
  products: [.framework(.dynamic)],
  dependencies: [
    .project(target: "Sign", path: .relativeToRoot("Features/Sign")),
    .project(target: "Chat", path: .relativeToRoot("Features/Chat")),
    .project(target: "Profile", path: .relativeToRoot("Features/Profile"))
  ]
)
