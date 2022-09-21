# :sparkles: small-apps

> 사이드 프로젝트를 모집하는 프로젝트 **connect**

## Git Flow

> 브런치 네이밍과 관리하는 방법에 대한 내용. 브런치 생성 및 반영시 참고해주세요!

:link: [Git Flow(Notion)](https://hexagonal-windshield-18a.notion.site/52d682c650604c18a866f112af9f9d04)

## Git Message

> 깃 커밋 메시지 작성시 규칙을 지켜서 커밋을 작성해주세요!
> (하단 참고링크에 템플릿과는 다른 내용 입니다. 글자수 및 설명이 더 자세해서 가져왔어요)

```
# <키워드>: <제목>
############### 제목은 50자 까지 ################# ->|

# 본문 내용
######### 본문 내용은 72자 까지 ####################################### -> |

# 한 줄 내용은 그냥 작성한다
# - 여러 줄일 때는 맨 앞에 '-'를 넣는다

# --- COMMIT END ---
#
# 키워드
#   fix (수정) : 동작, 오타 등을 고쳤을 때 #(이슈 넘버 혹은 URL)
#   feat (기능) : 기능 추가 시
#   refactor (리팩토링) : 기존 코드 리팩토링 진행
#   docs (문서) : 코드 파일단위 추가, 수정, 삭제, 이동 등
#   test (테스트) : 테스트 작성 및 수정
#   style (디자인) : css 등 코드작업이 아닌 디자인 작업
#   build (빌드) : 라이브러리 추가 삭제 등 빌드단위 설정 변경
# ------------------
# 규칙
#   - 제목줄은 대문자로 시작한다.
#   - 제목줄은 명령어로 작성한다.
#   - 제목줄은 마침표로 끝내지 않는다.
#   - 본문과 제목에는 빈줄을 넣어서 구분한다.
#   - 본문에는 "어떻게" 보다는 "왜"와 "무엇을" 설명한다.
#   - 본문에 목록을 나타낼때는 "-"로 시작한다.
# --------------------
```

:link: [커밋 메시지 템플릿 적용방법](https://velog.io/@bky373/Git-%EC%BB%A4%EB%B0%8B-%EB%A9%94%EC%8B%9C%EC%A7%80-%ED%85%9C%ED%94%8C%EB%A6%BF)

---

## Tuist

> 프로젝트 파일 및 폴더 변경시 .xcodeproj가 수시로 변경되어 협업시 빈번한 깃 충돌등의 이슈 해결을 위해 사용합니다.

 :exclamation: **주의! CocoaPod 라이브러리 사용으로 아래순서에 따라 명령어 진행 필요**

> :one: **`tuist fetch`**
> SPM, Carthage로 정의된 외부 라이브러리를 가져온다.

> :two: **`TUIST_EXCLUEDED_FRAMEWORK=TRUE tuist generate && pod install`** 
> CocoaPod을 사용한 라이브러리 제외하고 빌드 진행 && 이후 CocoaPod을 이용하여 라이브러리 가져온다.

> :three: **`Xcode Close`** 
> Xcode를 종료한다 (명령어 아님 수동으로 완전종료 진행한다).

> :four: **`tuist generate`** 
> 모든 의존성을 포함하여 Xcode workspace 생성한다.

* 대표 명령어 3가지
> :one: **`tuist generate`**
> Project.swift 파일에 작성된 내용대로 프로젝트 생성 명령어.

> :two: **`tuist edit`** 
> Tuist 설정을 변경하고 싶다면 Project.swift 파일 수정시 명령어.

> :three: **`tuist fetch`** 
> Dependencies.swift에 작성된 외부 라이브러리 반영시 명령어.
> 최초 라이브러리 반영이후 Dependencies.swift 내용에 변동이 없다면 추가 수행하지 않아도 됩니다.

#### Project+Templates.swift
> 프로젝트 생성을 위한 템플릿 파일

```swift
//  Project+Templates.swift
import ProjectDescription

extension Project {
  public static func feature(
    name: String,                      // 설정할 모듈의 이름
    bundleId: String = "",             // 'com.sideproj.\(name)' 대신 사용할 번들 Id (Option)
    products: [COProduct],             // .framework(.dynamic | .static) 프레임워크 지정
    isExcludedFramework: Bool = false, // CocoaPod사용으로 Pod에 해당하는 프레임워크를 제외하고 빌드하기 위한 환경변수.
    infoExtension: [String: InfoPlist.Value] = [:], // 기본 지정된 info.plist에 더 추가할 내용이 있는경우 작성.
    settings: Settings? = .default,
    dependencies: [TargetDependency] = [],          // 해당 모듈의 의존성.
    testDependencies: [TargetDependency] = [],      // 테스트용 의존성.
    externalDependencies: [TargetDependency] = []   // isExcludedFramework에 해당하는 의존성.
  ) -> Project {
    
    var targets: [Target] = []
    var schemes: [Scheme] = []
    
    var infoPlist: InfoPlist = .base(name: name)
    
    if !infoExtension.isEmpty {
      infoPlist = .custom(
        name: name,
        bundleId: bundleId,
        extentions: infoExtension
      )
    }
    
    // 메인 앱 타겟.
    if products.contains(.app) {
      let target: Target = .init(
        name: name,
        platform: .iOS,
        product: .app,
        bundleId: bundleId.isEmpty ? "com.sideproj.\(name)" : bundleId,
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        infoPlist: infoPlist,
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        entitlements: .relativeToRoot("App/connect.entitlements"),
        dependencies: isExcludedFramework ? dependencies : dependencies + externalDependencies,
        settings: settings
      )
      targets.append(target)
    }
    
    // Feature 모듈 데모 앱 타겟.
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
    
    // static, dynamic 프레임워크 타켓.
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
        dependencies: isExcludedFramework ? dependencies : dependencies + externalDependencies,
        settings: settings
      )
      targets.append(frameworkTarget)
    }
    
    // static, dynamic 라이브러리 타켓.
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
        dependencies: isExcludedFramework ? dependencies : dependencies + externalDependencies,
        settings: settings
      )
      targets.append(target)
    }
    
    // 유닛테스트 타켓.
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
    
    // UI테스트 타켓.
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
```

#### Project.swift
```swift
import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

// CocoaPod 라이브러리 최초 install시 프로젝트 파일이 없는경우 빌드제외시키기 위한 환경변수.
let excludedFramework = ProcessInfo.processInfo.environment["TUIST_EXCLUEDED_FRAMEWORK"]
let isExcludedFramework = (excludedFramework == "TRUE")

let app = Project.feature(
  name: "App",
  bundleId: "com.sideproj.connect",
  products: [.app, .unitTests, .uiTests],
  isExcludedFramework: isExcludedFramework,
  infoExtension: [
    "LSApplicationQueriesSchemes": .array(
      [.string("kakaokompassauth"), .string("naversearchapp"), .string("naversearchthirdlogin")]
    ),
    "CFBundleURLTypes": .array([
      .dictionary([
        "CFBundleURLSchemes": .array(["connectIT"]),
        "CFBundleURLName": .string("connectIT")
      ]),
      .dictionary([
        "CFBundleURLSchemes": .array(["kakaoee72a7c08c0e36ae98010b8d02f646cf"])
      ])
    ]),
    "NMFClientId": .string("y5sse5c8he"),
    "NSLocationAlwaysAndWhenInUseUsageDescription": .string("사용자의 위치를 가져옵니다."),
    "NSLocationWhenInUseUsageDescription": .string("사용자의 위치를 가져옵니다."),
    "NSLocationAlwaysUsageDescription": .string("사용자의 위치를 가져옵니다.")
  ],
  dependencies: [
    .project(target: "COFoundation", path: .relativeToRoot("Core/COFoundation")),
    .project(target: "COCommonUI", path: .relativeToRoot("UI/COCommonUI")),
    .project(target: "COThirdParty", path: .relativeToRoot("Core/COThirdParty")),
  ],
  externalDependencies: [
    .project(target: "Sign", path: .relativeToRoot("Features/Sign")),
    .xcframework(path: .CocoaPods.Framework.naverLogin),
    .xcframework(path: .CocoaPods.Framework.naverMaps)
  ]
)
```

#### Dependencies.swift
> 외부 라이브러리 의존성관리 내용 업데이트 적용시 **`tuist fetch`** 터미널 명령어 실행합니다.

```swift
import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: [ // SPM 사용 예시
    .remote(
      url: "https://github.com/ReactorKit/ReactorKit.git", /// 원격 저장소 주소와
      requirement: .upToNextMajor(from: "3.0.0")           /// 버전을 기입한다.
    ),
    .remote(
      url: "https://github.com/SnapKit/SnapKit.git",
      requirement: .upToNextMajor(from: "5.0.1")
    )
  ],
  platforms: [.iOS]
)
```

---

## ReactorKit

> ReactorKit은 **단방향 데이터 처리**가 특징이며, Reactor(ViewModel의 역할)의 형태가 정형화 되어있습니다.

> 한번 코드흐름을 파악해두면 다른 개발자가 작성한 코드 처리또한 대부분 동일하기 때문에 **협업시 다른 개발자의 코드를 파악할때 유리할것으로 생각**되어 반영 하였습니다.

>  RxSwift에 종속되어 있는 라이브러리로 RxSwift는 자동으로 포함됩니다.

### Flow

> Flow는 Action(View에 의해 전달된 이벤트) -> mutate(Action -> Mutation 변경) -> reduce(Mutation -> State로 처리되며
> View의 이벤트를 Reactor가 전달받아 변경된 State를 View에서 감지하여 프로그래밍하는 방식 입니다.


> 아래 그림과 예시코드를 같이 참고하시는걸 추천합니다!

![](https://cloud.githubusercontent.com/assets/931655/25098066/2de21a28-23e2-11e7-8a41-d33d199dd951.png)

### 예시코드

> ReactorKit에서 제공하는 제일 간단한 예제 입니다. 참고 부탁드립니다.
:link: [Counter Example](https://github.com/ReactorKit/ReactorKit/tree/master/Examples/Counter)

> Github 저장소
:link: [Github](https://github.com/ReactorKit/ReactorKit)

---

## Figma

> https://www.figma.com/file/HIaDgCj3MSYDaExhvz8FBl/%EC%82%AC%EC%9D%B4%EB%93%9C%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8?node-id=19%3A379
