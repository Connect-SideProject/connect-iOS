import ProjectDescription

let projectName: String = "connect"
let organizationName: String = "sideproj"
let bundleName: String = "com.sideproj"
let bundleID: String = "com.sideproj.connect"

let baseSetting: [String: SettingValue] = [
  "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
  "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"
]

/// info.plist 내용 지정.
let infoPlist: [String: InfoPlist.Value] = [
  "CFBundleName": "\(projectName)",
  "CFBundleDisplayName": "\(projectName)",
  "CFBundleIdentifier": "\(bundleID)",
  "CFBundleShortVersionString": "1.0",
  "CFBundleVersion": "0",
  "CFBuildVersion": "0",
  "UILaunchStoryboardName": "Launch Screen",
  "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
  "UIUserInterfaceStyle": "Light",
  "UIApplicationSceneManifest": [
    "UIApplicationSupportsMultipleScenes": false,
    "UISceneConfigurations": [
      "UIWindowSceneSessionRoleApplication": [
        [
          "UISceneConfigurationName": "Default Configuration",
          "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
        ]
      ]
    ]
  ]
]

let settings: Settings = .settings(
  base: baseSetting,
  configurations: [
    .release(name: .release)
  ],
  defaultSettings: .recommended
)

let targets = [
  Target(
    name: projectName,
    platform: .iOS,
    product: .app,
    bundleId: "\(bundleID)",
    deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: "Sources/**",
    resources: "Resources/**",
    dependencies: [
      /// Dependencies.swift에 정의된 외부 라이브러리 설정
      .external(name: "ReactorKit"),
      .external(name: "SnapKit")
    ],
    settings: settings
  ),
  Target(
    name: "\(projectName)Tests",
    platform: .iOS,
    product: .unitTests,
    bundleId: "\(bundleName).\(projectName)Tests",
    sources: "\(projectName)Tests/**",
    dependencies: [
      .target(name: projectName)
    ]
        ),
  Target(
    name: "\(projectName)UITests",
    platform: .iOS,
    product: .uiTests,
    bundleId: "\(bundleName).\(projectName)UITests",
    sources: "\(projectName)UITests/**",
    dependencies: [
      .target(name: projectName)
    ]
  )
]

let project = Project(
  name: projectName,
  organizationName: organizationName,
  targets: targets
)
