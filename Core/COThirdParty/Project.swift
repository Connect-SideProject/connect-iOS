import ProjectDescription
import ProjectDescriptionHelpers

let thirdParty = Project.feature(
  name: "COThirdParty",
  products: [.framework(.dynamic)],
  dependencies: [
    .ThirdParty.Auth.kakao,
    .ThirdParty.Reactive.reactorKit,
    .ThirdParty.Reactive.rxCocoa,
    .ThirdParty.Reactive.rxDataSources,
    .ThirdParty.Reactive.rxGesture,
    .ThirdParty.UI.flexLayout,
    .ThirdParty.UI.pinLayout,
    .ThirdParty.UI.snapKit,
    .ThirdParty.UI.then,
    .ThirdParty.UI.floatingPanel,
    .ThirdParty.UI.appleCalendar
  ]
)
