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
    products: [COProduct],
    infoExtension: [String: InfoPlist.Value] = [:],
    settings: Settings? = .default,
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = []
  ) -> Project {
    
    var targets: [Target] = []
    var schemes: [Scheme] = []
    
    var infoPlist: InfoPlist = .base(name: name)
    
    if !infoExtension.isEmpty {
      infoPlist = .custom(name: name, extentions: infoExtension)
    }
    
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
    
    if products.contains(.demoApp) {
      let appTarget: Target = .init(
        name: "\(name)DemoApp",
        platform: .iOS,
        product: .app,
        bundleId: "com.sideproj.\(name)DemoApp",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        infoPlist: .base(name: "\(name)DemoApp"),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: [.target(name: name)],
        settings: settings
      )
      targets.append(appTarget)
      
      let scheme: Scheme = .init(
        name: "\(name)DemoApp",
        shared: true,
        hidden: false,
        buildAction: .init(targets: ["\(name)DemoApp"]),
        runAction: .runAction(executable: "\(name)DemoApp")
      )
      
      schemes.append(scheme)
    }
    
    if products.filter({ $0.isFramework }).count != 0 {
      
      let frameworkTarget: Target = .init(
        name: name,
        platform: .iOS,
        product: products.contains(.framework(.static)) ? .staticFramework : .framework,
        bundleId: "com.sideproj.\(name)",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        infoPlist: infoPlist,
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: dependencies,
        settings: settings
      )
      targets.append(frameworkTarget)
    }
    
    if products.filter({ $0.isLibrary }).count != 0 {
      let target: Target = .init(
        name: name,
        platform: .iOS,
        product: products.contains(.library(.static)) ? .staticLibrary : .dynamicLibrary,
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
      
      var dependencies: [TargetDependency] = [.target(name: name), .xctest]
      dependencies += testDependencies
      
      let target: Target = .init(
        name: "\(name)Tests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "com.sideproj.\(name)Tests",
        infoPlist: .default,
        sources: ["\(name)Tests/**"],
        resources: ["\(name)Tests/**"],
        dependencies: dependencies
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
      targets: targets,
      schemes: schemes
    )
  }
}

extension Product {

  var isFramework: Bool {
    return (self == Product.staticFramework || self == Product.framework)
  }
  
  var isLibrary: Bool {
    return (self == Product.staticLibrary || self == Product.dynamicLibrary)
  }
}
