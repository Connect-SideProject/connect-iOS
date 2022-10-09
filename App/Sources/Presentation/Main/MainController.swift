//
//  MainController.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

import Profile
import COManager
import CONetwork

/// 하단 탭바가 포함된 화면 컨트롤러.
final class MainController: UITabBarController {
  
  private var profileNavigationController: UINavigationController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setViewContaollers()
    setupTabBar()
  }
}

extension MainController {
  /// 탭바 메뉴당 화면 설정(추후 아이콘 등 설정).
  private func setViewContaollers() {
    
    /// 홈 화면.
    let homeController = HomeController()
    homeController.tabBarItem = .init(
      title: "main.tabItem.home".localized(),
      image: nil,
      selectedImage: nil
    )
    
    /// 지도 화면.
    let mapController = MapController()
    mapController.tabBarItem = .init(
      title: "main.tabItem.map".localized(),
      image: nil,
      selectedImage: nil
    )
    
    /// 채팅 화면.
    let messageController = MessaeController()
    messageController.tabBarItem = .init(
      title: "main.tabItem.message".localized(),
      image: nil,
      selectedImage: nil
    )
    
    /// MY 화면.
    let profileDIContainer = ProfileDIContainer(
      apiService: ApiManager.shared,
      userService: UserManager.shared,
      roleSkillsService: RoleSkillsManager.shared,
      type: .base
    )
    if let profileController = profileDIContainer.makeController() as? ProfileController {
      profileController.delegate = self
      profileNavigationController = UINavigationController(
        rootViewController: profileController
      )
      profileNavigationController.tabBarItem = .init(
        title: "main.tabItem.profile".localized(),
        image: nil,
        selectedImage: nil
      )
    }
    
    self.viewControllers = [
      homeController,
      mapController,
      messageController,
      profileNavigationController
    ]
  }
  
  /// 탭바 커스텀 설정.
  private func setupTabBar() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      .font: UIFont.systemFont(ofSize: 12, weight: .medium),
      .foregroundColor: UIColor.gray
    ]
    
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
      .font: UIFont.systemFont(ofSize: 12, weight: .medium),
      .foregroundColor: UIColor.blue
    ]
    
    self.tabBar.standardAppearance = appearance
    self.tabBar.scrollEdgeAppearance = appearance
    
    self.tabBar.backgroundColor = .white
    self.tabBar.layer.borderWidth = 1
    self.tabBar.layer.borderColor = UIColor.white.cgColor
  }
}

extension MainController: ProfileControllerDelegate {
  func routeToEditProfile() {
    
    let viewController = UIViewController()
    profileNavigationController.pushViewController(viewController, animated: true)
  }
}
