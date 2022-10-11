//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/09/28.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let auth = Project.feature(
  name: "COAuth",
  products: [.framework(.dynamic)],
  dependencies: []
)
