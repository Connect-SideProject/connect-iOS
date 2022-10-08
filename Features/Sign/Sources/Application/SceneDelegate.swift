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
  
  var controller: UINavigationController!

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let scene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: scene)
    
    let container = SignInDIContainer(
      apiService: ApiManaerStub(state: .response(204)),
      userService: UserManagerStub()
    )
    
    let signController = container.makeController()
    signController.delegate = self
    
    controller = UINavigationController(
      rootViewController: signController
    )
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }
}

extension SceneDelegate: SignInDelegate {
  func routeToSignUp(authType: AuthType, accessToken: String) {
    let container = SignUpDIContainer(
      apiService: ApiManaerStub(),
      userService: UserManagerStub(),
      roleSkillsService: RoleSkillsManagerStub(isExists: true),
      authType: authType,
      accessToken: accessToken
    )
    let signUpController = container.makeController()
    signUpController.delegate = self
    controller.pushViewController(signUpController, animated: true)
  }
}

extension SceneDelegate: SignUpDelegate {
  func routeToHome() {
    controller.pushViewController(UIViewController(), animated: true)
  }
}
