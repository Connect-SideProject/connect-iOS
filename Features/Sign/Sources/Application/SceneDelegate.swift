//
//  SceneDelegate.swift
//  connect-iOSTests
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 butterfree. All rights reserved.
//

import UIKit

import COManager
import CONetwork

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  var controller: UINavigationController!

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let scene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: scene)
    
    let container = SignInDIContainer(
      apiService: ApiManaerStub(state: .response(204)),
      userService: UserManagerStub(),
      delegate: self
    )
    
    controller = UINavigationController(
      rootViewController: container.makeController()
    )
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }
}

extension SceneDelegate: SignInDelegate {
  func routeToSignUp() {
    let signUpController = SignUpController()
    controller.pushViewController(signUpController, animated: true)
  }
}
