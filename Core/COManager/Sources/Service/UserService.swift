//
//  UserService.swift
//  COManager
//
//  Created by sean on 2022/09/05.
//

import Foundation

import CODomain

public protocol UserService {
  var isExists: Bool { get }
  var accessToken: String { get }
  var profile: Profile? { get }
  func update(accessToken: String?, profile: Profile?)
  func remove()
}
