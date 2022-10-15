//
//  Tests.swift
//  connect-iOSTests
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 butterfree. All rights reserved.
//

@testable import App

import XCTest

import CODomain
import COExtensions
import COManager

final class NSKeyedArchiveTests: XCTestCase {
  
  var profile: Profile!
  let userService: UserService = UserManager.shared
  
  override func setUp() {
    super.setUp()
    
    let data = JSON.profile.data(using: .utf8)!
    do {
      profile = try JSONDecoder().decode(Base<Profile>.self, from: data).data
    } catch let error {
      print(error)
    }
  }
  
  override func tearDown() {
    super.tearDown()
    
    profile = nil
  }
  
  func test_profile_archive() {
    userService.update(accessToken: "", profile: profile)
    XCTAssertNotNil(userService.profile)
    XCTAssertNotNil(userService.profile?.authType)
    XCTAssertNotNil(userService.profile?.nickname)
    XCTAssertNotEqual(userService.profile?.roles, [])
    XCTAssertNotNil(userService.profile?.region)
    XCTAssertNotEqual(userService.profile?.interestings, [])
    XCTAssertNotNil(userService.profile?.profileURL)
    XCTAssertNotNil(userService.profile?.portfolioURL)
    XCTAssertNotNil(userService.profile?.career)
    XCTAssertNotEqual(userService.profile?.skills, [])
  }
  
  func test_profile_unArchive() {
    userService.update(accessToken: "", profile: profile)
    
    XCTAssertEqual(userService.profile?.authType, profile.authType)
    XCTAssertEqual(userService.profile?.nickname, profile.nickname)
    XCTAssertEqual(userService.profile?.roles, profile.roles)
    XCTAssertEqual(userService.profile?.region?.description, profile.region?.description)
    XCTAssertEqual(userService.profile?.interestings, profile.interestings)
    XCTAssertEqual(userService.profile?.profileURL, profile.profileURL)
    XCTAssertEqual(userService.profile?.portfolioURL, profile.portfolioURL)
    XCTAssertEqual(userService.profile?.career, profile.career)
    XCTAssertEqual(userService.profile?.skills, profile.skills)
  }
}
