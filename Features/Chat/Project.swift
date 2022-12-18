//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Taeyoung Son on 2022/11/04.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let profile = Project.feature(
  name: "Chat",
  products: [.framework(.static), .demoApp, .unitTests],
  dependencies: [
    .Project.UI.common,
    .Project.Core.foundation
  ]
)
