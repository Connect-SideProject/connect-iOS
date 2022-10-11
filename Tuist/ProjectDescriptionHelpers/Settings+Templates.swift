//
//  Settings+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/08/31.
//

import ProjectDescription

extension Settings {
  
  public static var `default`: Self {
    
    let baseSetting: [String: SettingValue] = [:]
    
    return .settings(
      base: baseSetting,
      configurations: [
        .release(name: .release)
      ],
      defaultSettings: .recommended
    )
  }
}
