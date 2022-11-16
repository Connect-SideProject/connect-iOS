//
//  SceneDelegate.swift
//  connect-iOSTests
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 butterfree. All rights reserved.
//

import UIKit

import CODomain
import COManager
import CONetwork

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let scene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: scene)

    let controller = MeetingCreateViewController()
    controller.reactor = .init(
      apiService: ApiManaerStub(),
      userService: UserManagerStub(),
      interestService: InterestManagerStub(isExists: true),
      addressService: AddressManager.shared
    )
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }
}
