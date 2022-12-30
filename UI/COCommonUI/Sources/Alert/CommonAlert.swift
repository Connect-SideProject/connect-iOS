//
//  CommonAlert.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation
import UIKit

import COExtensions

public enum MessageType: CustomStringConvertible, Equatable {
  case needSignIn
  case message(String)
  
  public var description: String {
    switch self {
    case .needSignIn:
      return "로그인이 필요합니다."
    case .message(let string):
      return string
    }
  }
}

public enum AlertButtonType {
  case confirm, cancel
}

public final class CommonAlert: UIAlertController {
  
  public static let shared: CommonAlert = CommonAlert(extra: "")
  
  public var confirmHandler: () -> Void = {}
  public var cancelHandler: () -> Void = {}
  
  private convenience init(
    title: String = "",
    message: String = "",
    preferredStyle: UIAlertController.Style = .alert,
    extra: String
  ){
    self.init(title: title, message: message, preferredStyle: preferredStyle)
  }
  
  /// 1. 타이틀 설정.
  @discardableResult
  public func setTitle(_ title: String) -> Self {
    self.title = title
    return self
  }
  
  /// 2. 메세지 설정.
  @discardableResult
  public func setMessage(_ message: MessageType) -> Self {
    
    switch message {
    case .needSignIn:
      self.message = message.description
    case .message(let string):
      self.message = string
    }
    
    return self
  }
  
  /// 3. 버튼 설정.
  @discardableResult
  public func appendButton(type: AlertButtonType) -> Self {
    
    var action: UIAlertAction!
    
    switch type {
    case .confirm:
      action = .init(
        title: "확인",
        style: .default,
        handler: { [weak self] _ in
          self?.confirmHandler()
        })
    case .cancel:
      action = .init(
        title: "취소",
        style: .cancel,
        handler: { [weak self] _ in
          self?.cancelHandler()
        })
    }
    
    addAction(action)
    return self
  }
  
  /// 4. Alert 노출.
  @discardableResult
  public func show(viewController: UIViewController? = nil) -> Self {
    
    if actions.isEmpty {
      let action: UIAlertAction = .init(
        title: "확인",
        style: .default,
        handler: { [weak self] _ in
          self?.confirmHandler()
        })
      addAction(action)
    }
    
    DispatchQueue.main.async {
      var controller: UIViewController?
      if let viewController = viewController {
        controller = viewController
      } else {
        controller = UIApplication.getTopViewController()
      }
      // alert이 띄워질 컨트롤러가 최상위가 아니라면 리턴.
      guard controller?.presentedViewController == nil else { return }
      
      controller?.present(self, animated: true)
    }
    
    return self
  }
}
