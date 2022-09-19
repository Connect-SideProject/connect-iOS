//
//  Workspace.swift
//  Dependencies
//
//  Created by sean on 2022/09/03.
//

import ProjectDescription

let workspace = Workspace(
  name: "connect",
  projects: [
    "App/**",
    "Features/**",
    "Core/**",
    "Domain/**",
    "UI/**"
  ]
)
