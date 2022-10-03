//
//  UserService.swift
//  COManager
//
//  Created by sean on 2022/09/05.
//

import Foundation

import CODomain

public protocol UserService {
  var accessToken: String { get }
  var profile: Profile? { get }
  func update(accessToken: String)
  func update(profile: Profile)
  func remove()
}
