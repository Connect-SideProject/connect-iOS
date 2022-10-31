//
//  SceneDelegate.swift
//  connect-iOSTests
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 butterfree. All rights reserved.
//

import UIKit

import COCommonUI
import CODomain
import COManager
import CONetwork
import Sign

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  var controller: CONavigationViewController!
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: scene)
    
    let controller = SplashController()
    controller.reactor = .init()
    controller.delegate = self
    
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }
}

extension SceneDelegate: SplashDelegate {
  func didFinishSplashLoading() {
    
    /// 로그인 상태 체크.
    if UserManager.shared.tokens.isEmpty {
      let container = SignInDIContainer(
        apiService: ApiManager.shared,
        userService: UserManager.shared
      )
      
      let signInController = container.makeController()
      signInController.delegate = self
      
      controller = CONavigationViewController(
        rootViewController: signInController
      )
    } else {
      controller = CONavigationViewController(
        rootViewController: MainController()
      )
    }
    
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }
}

extension SceneDelegate: SignInDelegate {
  func routeToSignUp(authType: CODomain.AuthType, accessToken: String) {
    let container = SignUpDIContainer(
      apiService: ApiManager.shared,
      userService: UserManager.shared,
      addressService: AddressManager.shared,
      interestService: InterestManager.shared,
      roleSkillsService: RoleSkillsManager.shared,
      authType: authType,
      accessToken: accessToken
    )
    
    let signUpController = container.makeController()
    signUpController.delegate = self
    controller.pushViewController(signUpController, animated: true)
  }
}

extension SceneDelegate: SignUpDelegate {
  func routeToMain() {
    controller.pushViewController(MainController(), animated: true)
  }
}
