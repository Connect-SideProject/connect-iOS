//
//  AppDelegate.swift
//  connect-iOSTests
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 butterfree. All rights reserved.
//

import UIKit

import KakaoSDKCommon
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    
    // Kakao sdk
    KakaoSDK.initSDK(appKey: "ee72a7c08c0e36ae98010b8d02f646cf")
    
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
