//
//  CONavigationViewController.swift
//  COCommonUI
//
//  Created by sean on 2022/10/23.
//

import UIKit

public final class CONavigationViewController: UINavigationController {
  
  public override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
    if #available(iOS 16.1, *) {
      navigationBar.setNeedsLayout()
      navigationBar.layoutIfNeeded()
    }
    
    super.setNavigationBarHidden(hidden, animated: animated)
  }
  
}
