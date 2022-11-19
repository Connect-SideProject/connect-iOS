//
//  SceneDelegate.swift
//  ChatDemoApp
//
//  Created by Taeyoung Son on 2022/11/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = .init(windowScene: scene)
        
        let chatListC = ChatListDIContainer().makeVC()
        
        let navC = UINavigationController(rootViewController: chatListC)
        self.window?.rootViewController = navC
        self.window?.makeKeyAndVisible()
    }
}
