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
    .Project.Features.sign,
    .Project.Features.chat,
    .Project.Features.meeting,
    .Project.Features.profile
  ]
)
