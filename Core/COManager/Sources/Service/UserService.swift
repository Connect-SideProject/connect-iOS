//
//  UserService.swift
//  COManager
//
//  Created by sean on 2022/09/05.
//

import Foundation

import CODomain

public struct Tokens {
  public var access: String = ""
  public var refresh: String = ""
  
  public init(access: String = "", refresh: String = "") {
    self.access = access
    self.refresh = refresh
  }
}

public extension Tokens {
  var isEmpty: Bool {
    return access.isEmpty || refresh.isEmpty
  }
}

public protocol UserService {
  var isExists: Bool { get }
  var tokens: Tokens { get }
  var profile: Profile? { get }
  func update(tokens: Tokens?, profile: Profile?)
  func remove()
}
