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

* 대표 명령어 3가지
> :one: **`tuist generate`**
> Project.swift 파일에 작성된 내용대로 프로젝트 생성 명령어.

> :two: **`tuist edit`** 
> Tuist 설정을 변경하고 싶다면 Project.swift 파일 수정시 명령어.

> :three: **`tuist fetch`** 
> Dependencies.swift에 작성된 외부 라이브러리 반영시 명령어.
> 최초 라이브러리 반영이후 Dependencies.swift 내용에 변동이 없다면 추가 수행하지 않아도 됩니다.

#### Project.swift
> 프로젝트 생성을 위한 정보가 담긴 파일

```swift
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
/// 프로젝트에서 필요한 info.plist 내용을 Key:Value의 형태로 작성한다.
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
  ],
  /// 추가 설정항목 작성.
]

/// Target 별 기본 설정항목. 
/// (별도 필요한 설정이 있는지 잘 모르겠음. 우선 예제대로 작성.)
let settings: Settings = .settings(
  base: baseSetting,
  configurations: [
    .release(name: .release)
  ],
  defaultSettings: .recommended
)

let targets = [
  /// 앱 메인.
  Target(
    name: projectName,
    platform: .iOS,
    product: .app,
    bundleId: "\(bundleID)",
    deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]), /// 개발환경 최소 버전.
    infoPlist: .extendingDefault(with: infoPlist), /// 상단에 작성된 info.plist내용 반영을 위해 설정.
    sources: "Sources/**",                         /// 앱 개발시 작성되는 코드 영역의 경로 설정.
    resources: "Resources/**",                     /// 개발시 필요한 사진파일이나 등등의 리소스 경로 설정.
    dependencies: [
      /// Dependencies.swift에 정의된 외부 라이브러리 설정
      .external(name: "ReactorKit"),
      .external(name: "SnapKit")
    ],
    settings: settings
  ),
  /// 테스트.
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
  /// UI 테스트.
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
