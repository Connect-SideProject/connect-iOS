//
//  SignUpController.swift
//  Sign
//
//  Created by sean on 2022/09/06.
//

import UIKit

final class SignUpController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
}

extension SignUpController {
  private func configureUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    view.backgroundColor = .red
  }
}
