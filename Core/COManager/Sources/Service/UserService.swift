//
//  UserService.swift
//  COManager
//
//  Created by sean on 2022/09/05.
//

import Foundation

public protocol UserService {
  var accessToken: String { get }
  func update(accessToken: String)
  func remove()
}
