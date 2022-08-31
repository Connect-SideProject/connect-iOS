//
//  Project+Templates.swift
//  Manifests
//
//  Created by sean on 2022/08/07.
//

import ProjectDescription

extension Project {
  public static func feature(
    name: String,
    products: [Product],
    settings: Settings? = .default,
    dependencies: [TargetDependency] = []
  ) -> Project {
    
    var targets: [Target] = []
    
    let infoPlist: InfoPlist = .default(name: name)
    
    if products.contains(.app) {
      let target: Target = .init(
        name: name,
        platform: .iOS,
        product: .app,
        bundleId: "com.sideproj.\(name)",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        infoPlist: infoPlist,
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: dependencies,
        settings: settings
      )
      targets.append(target)
    }
    
    products.filter { $0.isFramework }
      .forEach {
        let target: Target = .init(
          name: name,
          platform: .iOS,
          product: $0,
          bundleId: "com.sideproj.\(name)",
          deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
          infoPlist: infoPlist,
          sources: ["Sources/**"],
          resources: ["Resources/**"],
          dependencies: dependencies,
          settings: settings
        )
        targets.append(target)
      }
    
    products.filter { $0.isLibrary }
      .forEach {
        let target: Target = .init(
          name: name,
          platform: .iOS,
          product: $0,
          bundleId: "com.sideproj.\(name)",
          deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
          infoPlist: infoPlist,
          sources: ["Sources/**"],
          resources: ["Resources/**"],
          dependencies: dependencies,
          settings: settings
        )
        targets.append(target)
      }
    
    if products.contains(.unitTests) {
      let target: Target = .init(
        name: "\(name)Tests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "com.sideproj.\(name)Tests",
        infoPlist: .default,
        sources: ["\(name)Tests/**"],
        resources: ["\(name)Tests/**"],
        dependencies: [.target(name: name)]
      )
      targets.append(target)
    }
    
    if products.contains(.uiTests) {
      let target: Target = .init(
        name: "\(name)UITests",
        platform: .iOS,
        product: .uiTests,
        bundleId: "com.sideproj.\(name)UITests",
        sources: "\(name)UITests/**",
        dependencies: [.target(name: name)]
      )
      targets.append(target)
    }
    
    return Project(
      name: name,
      targets: targets
    )
  }
}

extension Product {
  enum Environment {
    case `static`, `dynamic`
  }
  
  static func framework(_ environment: Environment) -> Self {
    return environment == .static ? .staticFramework : .framework
  }
  
  static func library(_ environment: Environment) -> Self {
    return environment == .static ? .staticLibrary : .dynamicLibrary
  }
  
  var isFramework: Bool {
    return (self == Product.staticFramework || self == Product.framework)
  }
  
  var isLibrary: Bool {
    return (self == Product.staticLibrary || self == Product.dynamicLibrary)
  }
}
