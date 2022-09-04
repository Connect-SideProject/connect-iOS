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
    infoDict: [String: InfoPlist.Value] = [:],
    settings: Settings? = .default,
    dependencies: [TargetDependency] = []
  ) -> Project {
    
    var targets: [Target] = []
    var schemes: [Scheme] = []
    
    var infoPlist: InfoPlist = .base(name: name)
    
    if !infoDict.isEmpty {
      infoPlist = .custom(name: name, extentions: infoDict)
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
    
    if products.filter({ $0.isFramework }).count != 0 {
      let appTarget: Target = .init(
        name: "\(name)App",
        platform: .iOS,
        product: .app,
        bundleId: "com.sideproj.\(name)App",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        infoPlist: infoPlist,
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: [.target(name: name)],
        settings: settings
      )
      targets.append(appTarget)
      
      let frameworkTarget: Target = .init(
        name: name,
        platform: .iOS,
        product: products.contains(.staticFramework) ? .staticFramework : .framework,
        bundleId: "com.sideproj.\(name)",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        infoPlist: infoPlist,
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: dependencies,
        settings: settings
      )
      targets.append(frameworkTarget)
      
      let scheme: Scheme = .init(
        name: "\(name)App",
        shared: true,
        hidden: false,
        buildAction: .init(targets: ["\(name)App"]),
        runAction: .runAction(executable: "\(name)App")
      )
      
      schemes.append(scheme)
    }
    
    if products.filter({ $0.isLibrary }).count != 0 {
      let target: Target = .init(
        name: name,
        platform: .iOS,
        product: products.contains(.staticLibrary) ? .staticLibrary : .dynamicLibrary,
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
