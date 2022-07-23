//
//  HomeCoordinator.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/12.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit


/// 홈 코디네이터
class HomeCoordinator: BaseCoordinator {
    var presenter: UINavigationController
    
    var childrenCoordinator: [BaseCoordinator]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childrenCoordinator = []
    }
    
//    func moveToListDetail() {
//        let listVC = PostListController()
//        presenter.pushViewController(listVC, animated: true)
//    }
    
}
