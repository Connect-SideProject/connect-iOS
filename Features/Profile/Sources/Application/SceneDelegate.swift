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
    
    let container = ProfileDIContainer(
      apiService: ApiManaerStub(),
      userService: UserManagerStub(),
      roleSkillsService: RoleSkillsManagerStub(isExists: true),
      type: .base
    )
    
    if let profileController = container.makeController() as? ProfileController {
      profileController.delegate = self
      controller = UINavigationController(
        rootViewController: profileController
      )
    }

    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }
}

extension SceneDelegate: ProfileControllerDelegate {
  func routeToEditProfile() {
    
    let container = ProfileDIContainer(
      apiService: ApiManaerStub(),
      userService: UserManagerStub(),
      roleSkillsService: RoleSkillsManagerStub(isExists: true),
      type: .edit
    )
    
    if let profileEditController = container.makeController() as? ProfileEditController {
      controller.pushViewController(profileEditController, animated: true)
    }
  }
}
