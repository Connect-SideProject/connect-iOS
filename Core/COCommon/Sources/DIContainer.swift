//
//  SignInDIContainer.swift
//  Sign
//
//  Created by sean on 2022/09/05.
//

import Foundation

public protocol DIContainer {
  associatedtype Reactor
  associatedtype Repository
  associatedtype UserCase
  associatedtype ViewController
  
  func makeReactor() -> Reactor
  func makeSignInRepository() -> Repository
  func makeSignInUseCase() -> UserCase
  func makeController() -> ViewController
}
