//
//  SceneDelegate.swift
//  connect-iOSTests
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 butterfree. All rights reserved.
//

import UIKit

import CONetwork
import Sign

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let scene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: scene)
    
    let controller = SplashController()
    controller.delegate = self
    
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }
}

extension SceneDelegate: SplashDelegate {
  func didFinishSplashLoading() {
    
    var controller: UIViewController!
    
    /// 로그인 상태 체크.
    if UserManager.shared.accessToken.isEmpty {
      let signIn = SignInController()
      signIn.reactor = .init(
        useCase: SignInUseCaseImpl(
          repository: SignInRepositoryImpl()
        )
      )
      controller = signIn
    } else {
      controller = MainController()
    }
    
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }
}
