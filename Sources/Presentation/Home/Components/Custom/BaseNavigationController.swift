//
//  BaseNavigationController.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/12.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit


/// 네비게이션 뷰 커스터마이징 
final class BaseNavigationViewController: UINavigationController {
    
    //MARK: Property
    private var homeTabbarView = HomeListHeaderView(frame: .zero)
    public var isHidden: Bool = false
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configure()
    }
        
    override func viewDidLayoutSubviews() {
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 125)
    }
    
    private func configure() {
        self.navigationBar.backgroundColor = .white
        
        guard isHidden == false else { return }
        navigationBar.addSubview(homeTabbarView)
        
        homeTabbarView.snp.makeConstraints {
            $0.bottom.left.right.equalTo(0)
            $0.height.equalTo(50)
            
        }
    }
}
