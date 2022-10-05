//
//  AppDelegate.swift
//  connect-iOSTests
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 butterfree. All rights reserved.
//

import UIKit

import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    
    // Naver sdk
    let loginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
    loginConnection?.isInAppOauthEnable = true
    loginConnection?.setOnlyPortraitSupportInIphone(true)
    
    loginConnection?.serviceUrlScheme = "connectIT"
    loginConnection?.consumerKey = "BfwBd4q2ahNf6l2YsJm4"
    loginConnection?.consumerSecret = "I2b0BHctlu"
    loginConnection?.appName = "connectIT"
    
    return true
  }
}
