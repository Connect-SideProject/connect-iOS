//
//  KeyboardResponder.swift
//  COCommon
//
//  Created by sean on 2022/11/10.
//

import Foundation
import UIKit

public protocol KeyboardResponder {
  var targetView: UIView { get }
}

public extension KeyboardResponder where Self: UIViewController {

  func registerNotifications() {
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardWillShowNotification,
      object: nil,
      queue: nil
    ) { [weak self] notification in
      self?.keyboardWillShow(notification)
    }

    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardWillHideNotification,
      object: nil,
      queue: nil
    ) { [weak self] notification in
      self?.keyboardWillHide(notification)
    }
  }

  func removeNotifications() {
    NotificationCenter.default.removeObserver(self)
  }

  func keyboardWillShow(_ notification: Notification) {

    guard let info = notification.userInfo as? [String: Any] else { return }
    guard let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

    let keyboardHeight = keyboardFrame.cgRectValue.height

    let targetPosition = targetView.superview?.convert(
      targetView.frame.origin,
      to: nil
    ) ?? targetView.frame.origin
    
    let bottomSpace = view.frame.height - targetPosition.y - targetView.frame.height

    guard keyboardHeight > bottomSpace else { return }

    let adjustHeight = keyboardHeight - bottomSpace

    UIView.animate(withDuration: 1) {
      self.view.bounds.origin.y = adjustHeight
    }
  }

  func keyboardWillHide(_ notification: Notification) {
    UIView.animate(withDuration: 1) {
      self.view.bounds.origin.y = 0
    }
  }
}
