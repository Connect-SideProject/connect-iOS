//
//  TargetDependency+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by sean on 2022/11/20.
//

import ProjectDescription

extension TargetDependency {
  public struct Project {
    public struct Auth {}
    public struct Core {}
    public struct Domain {}
    public struct Features {}
    public struct UI {}
  }
  
  public struct ThirdParty {
    public struct Auth {}
    public struct Reactive {}
    public struct UI {}
    public struct Log {}
  }
}

extension TargetDependency.Project.Auth {
  public static let auth: TargetDependency = .project(
    target: "COAuth",
    path: .relativeToRoot("Auth/COAuth")
  )
}

extension TargetDependency.Project.Core {
  public static let common: TargetDependency = .project(
    target: "COCommon",
    path: .relativeToRoot("Core/COCommon")
  )
  
  public static let foundation: TargetDependency = .project(
    target: "COFoundation",
    path: .relativeToRoot("Core/COFoundation")
  )
  
  public static let extensions: TargetDependency = .project(
    target: "COExtensions",
    path: .relativeToRoot("Core/COExtensions")
  )
  
  public static let network: TargetDependency = .project(
    target: "CONetwork",
    path: .relativeToRoot("Core/CONetwork")
  )
  
  public static let manager: TargetDependency = .project(
    target: "COManager",
    path: .relativeToRoot("Core/COManager")
  )
  
  public static let thirdParty: TargetDependency = .project(
    target: "COThirdParty",
    path: .relativeToRoot("Core/COThirdParty")
  )
    
  public static let log: TargetDependency = .project(
    target: "COLog",
    path: .relativeToRoot("Core/COLog")
  )
}

extension TargetDependency.Project.Domain {
  public static let domain: TargetDependency = .project(
    target: "CODomain",
    path: .relativeToRoot("Domain/CODomain")
  )
}

extension TargetDependency.Project.Features {
  public static let features: TargetDependency = .project(
    target: "COFeatures",
    path: .relativeToRoot("Features/COFeatures")
  )
  
  public static let sign: TargetDependency = .project(
    target: "Sign",
    path: .relativeToRoot("Features/Sign")
  )
  
  public static let chat: TargetDependency = .project(
    target: "Chat",
    path: .relativeToRoot("Features/Chat")
  )
  
  public static let meeting: TargetDependency = .project(
    target: "Meeting",
    path: .relativeToRoot("Features/Meeting")
  )
  
  public static let profile: TargetDependency = .project(
    target: "Profile",
    path: .relativeToRoot("Features/Profile")
  )
}

extension TargetDependency.Project.UI {
  public static let common: TargetDependency = .project(
    target: "COCommonUI",
    path: .relativeToRoot("UI/COCommonUI")
  )
}

extension TargetDependency.ThirdParty.Auth {
  public static let kakao: TargetDependency = .external(name: "KakaoSDKUser")
}

extension TargetDependency.ThirdParty.Reactive {
  public static let reactorKit: TargetDependency = .external(name: "ReactorKit")
  public static let rxCocoa: TargetDependency = .external(name: "RxCocoa")
  public static let rxDataSources: TargetDependency = .external(name: "RxDataSources")
  public static let rxGesture: TargetDependency = .external(name: "RxGesture")
}

extension TargetDependency.ThirdParty.Log {
    public static let googleAnalytics: TargetDependency = .external(name: "FirebaseAnalytics")
}

extension TargetDependency.ThirdParty.UI {
  public static let flexLayout: TargetDependency = .external(name: "FlexLayout")
  public static let pinLayout: TargetDependency = .external(name: "PinLayout")
  public static let snapKit: TargetDependency = .external(name: "SnapKit")
  public static let then: TargetDependency = .external(name: "Then")
  public static let floatingPanel: TargetDependency = .external(name: "FloatingPanel")
  public static let appleCalendar: TargetDependency = .external(name: "JTAppleCalendar")
}
