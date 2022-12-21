//
//  Notification+Extension.swift
//  COExtensions
//
//  Created by sean on 2022/11/01.
//

import Foundation

public enum NotificationType: String {
  case expiredToken
  case routeToSignIn
}

public extension Notification.Name {
    static let searchToPost = NSNotification.Name("searchToPost")
    
}

public extension NotificationCenter {

  func post(type: NotificationType, params: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
    self.post(name: Notification.Name(type.rawValue), object: params, userInfo: userInfo)
  }

  func add(observer: Any, selector: Selector, type: NotificationType, params: Any? = nil) {
    self.addObserver(observer, selector: selector, name: Notification.Name(type.rawValue), object: params)
  }

  func add(observer: Any, selector: Selector, types: [NotificationType], params: Any? = nil) {
    for type in types {
      add(observer: observer, selector: selector, type: type, params: params)
    }
  }
}
