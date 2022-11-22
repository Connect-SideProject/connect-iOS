//
//  MainController.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

import Profile
import COCommonUI
import COManager
import CONetwork

/// 코디네이터 인터페이스
protocol BaseCoordinator: AnyObject {
  var presenter: UINavigationController {get set}
  var childrenCoordinator: [BaseCoordinator] {get set}
}

/// 하단 탭바가 포함된 화면 컨트롤러.
final class MainController: UITabBarController {
  
  private var profileNavigationController: CONavigationViewController!
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setViewContaollers()
    setupTabBar()
  }
}

extension MainController {
  /// 탭바 메뉴당 화면 설정(추후 아이콘 등 설정).
  private func setViewContaollers() {
    
    /// 지도 화면.
    let mapController = MapController()
    mapController.tabBarItem = .init(
      title: "main.tabItem.map".localized(),
      image: .init(named: "ic_map_inactive")?.withRenderingMode(.alwaysOriginal),
      selectedImage: .init(named: "ic_map_active")?.withRenderingMode(.alwaysOriginal)
    )
    
    let homeDIContainer = HomeDependencyContainer(
      homeApiService: ApiManager.shared
    )
    
    /// 홈 화면
    let homeController = homeDIContainer.makeController()
    homeController.delegate = self
    homeController.tabBarItem = .init(
      title: "main.tabItem.home".localized(),
      image: .init(named: "ic_home_inactive")?.withRenderingMode(.alwaysOriginal),
      selectedImage: .init(named: "ic_home_active")?.withRenderingMode(.alwaysOriginal)
    )
    
    /// 채팅 화면.
    let messageController = MessaeController()
    messageController.tabBarItem = .init(
      title: "main.tabItem.message".localized(),
      image: .init(named: "ic_chat_inactive")?.withRenderingMode(.alwaysOriginal),
      selectedImage: .init(named: "ic_chat_active")?.withRenderingMode(.alwaysOriginal)
    )
    
    /// MY 화면.
    let profileDIContainer = ProfileDIContainer(
      apiService: ApiManager.shared,
      userService: UserManager.shared
    )
    
    let profileController = profileDIContainer.makeController()
    profileController.delegate = self
    profileNavigationController = CONavigationViewController(
      rootViewController: profileController
    )
    profileNavigationController.tabBarItem = .init(
      title: "main.tabItem.profile".localized(),
      image: .init(named: "ic_my_inactive")?.withRenderingMode(.alwaysOriginal),
      selectedImage: .init(named: "ic_my_active")?.withRenderingMode(.alwaysOriginal)
    )
    
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
    appearance.backgroundColor = .white
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      .font: UIFont.semiBold(size: 12),
      .foregroundColor: UIColor.hexC6C6C6
    ]
    
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
      .font: UIFont.regular(size: 12),
      .foregroundColor: UIColor.hex3A3A3A
    ]
    
    self.tabBar.standardAppearance = appearance
    self.tabBar.scrollEdgeAppearance = appearance
    
    self.tabBar.tintColor = .hexEDEDED
    self.tabBar.layer.borderWidth = 1
    self.tabBar.layer.borderColor = UIColor.white.cgColor
  }
}

extension MainController: ProfileDelegate {
  func routeToEditProfile() {
    let container = ProfileEditDIContainer(
      apiService: ApiManager.shared,
      userService: UserManager.shared,
      addressService: AddressManager.shared,
      interestService: InterestManager.shared,
      roleSkillsService: RoleSkillsManager.shared
    )
    
    let controller = container.makeController()
    controller.delegate = self
    profileNavigationController.pushViewController(controller, animated: true)
  }
}

extension MainController: ProfileEditDelegate {
  func routeToBack() {
    profileNavigationController.popViewController(animated: true)
  }
}


extension MainController: HomeCoordinatorDelegate {
    func didTapToPostListCreate() {
        let homeDependency = HomeDependencyContainer(homeApiService: ApiManager.shared)
        let childrenCoordinator = homeDependency.makeChildrenController()
        self.navigationController?.pushViewController(childrenCoordinator, animated: true)
    }
    
    func didTapToSearchCreate() {
        let searchDependency = SearchDependencyContainer(searchApiService: ApiManager.shared)
        self.navigationController?.pushViewController(searchDependency.makeController(), animated: true)
    }
}
