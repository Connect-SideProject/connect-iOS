//
//  SplashController.swift
//  connect
//
//  Created by sean on 2022/08/24.
//

import UIKit

protocol SplashDelegate: AnyObject {
  func didFinishSplashLoading()
}

/// 스플래쉬.
final class SplashController: UIViewController {
  
  weak var delegate: SplashDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// 로고 노출을 위한 Delay
    delegate?.didFinishSplashLoading()
  }
}
