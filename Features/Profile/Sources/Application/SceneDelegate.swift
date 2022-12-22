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
  
  private var navigationController: UINavigationController!

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let scene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: scene)
    
    let container = ProfileDIContainer(
      apiService: ApiManaerStub(),
      userService: UserManagerStub()
    )
    
    let controller = container.makeController()
    controller.delegate = self
    navigationController = UINavigationController(
      rootViewController: controller
    )

    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}

extension SceneDelegate: ProfileDelegate {
  func routeToEditProfile() {
    
    let container = ProfileEditDIContainer(
      apiService: ApiManaerStub(),
      userService: UserManagerStub(),
      addressService: AddressManager.shared,
      interestService: InterestManagerStub(isExists: true),
      roleSkillsService: RoleSkillsManagerStub(isExists: true)
    )
    
    let controller = container.makeController()
    controller.delegate = self
    navigationController.pushViewController(controller, animated: true)
  }
  
  func routeToSingIn() {
    
  }
    
  func routeToMyPost(_ type: ProfilePostType) {
    
  }
}

extension SceneDelegate: ProfileEditDelegate {
  func routeToBack() {
    navigationController.popViewController(animated: true)
  }
}
