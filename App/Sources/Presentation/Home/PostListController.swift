//
//  PostListController.swift
//  connect
//
//  Created by Kim dohyun on 2022/06/12.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

/// 프로젝트 리스트 화면 컨트롤러
class PostListController: UIViewController {
    
    private let latestListController: UIViewController
    
    //MARK: Property
    
    init(latestListController: UIViewController) {
        self.latestListController = latestListController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configure() {
        addChild(latestListController)
    }
    
    
}



// 프로젝트 리스트 화면 DI
extension PostListController {
    fileprivate func add(child childrenViewController: UIViewController) {
        beginUpdate(child: childrenViewController)
        view.addSubview(childrenViewController.view)
        endAddChild(child: childrenViewController)
    }
    
    fileprivate func remove(child childrenViewController: UIViewController) {
        guard parent != nil else { return }
        childrenViewController.beginAppearanceTransition(false, animated: false)
        childrenViewController.willMove(toParent: nil)
        childrenViewController.removeFromParent()
        childrenViewController.endAppearanceTransition()
        
    }
    
    fileprivate func beginUpdate(child childrenViewController: UIViewController) {
        childrenViewController.beginAppearanceTransition(true, animated: false)
        self.addChild(childrenViewController)
    }
    
    fileprivate func endAddChild(child childrenViewController: UIViewController) {
        childrenViewController.didMove(toParent: self)
        childrenViewController.endAppearanceTransition()
    }
}
