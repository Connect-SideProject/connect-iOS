//
//  IndicatorImageView.swift
//  connect
//
//  Created by sean on 2022/06/29.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation
import UIKit

/// 이미지 로딩 처리를 위해 indicatorView가 포함된 이미지 뷰.
final class IndicatorImageView: UIImageView {
  
  private var indicatorView: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()
  
  override var image: UIImage? {
    didSet {
      DispatchQueue.main.async {
        self.indicatorView.stopAnimating()
      }
    }
  }
  
  init() {
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(indicatorView)
    
    NSLayoutConstraint.activate([
      indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
      indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
    indicatorView.startAnimating()
  }
  
  /// indicatorView 애니메이션 취소.
  func stopLoading() {
    DispatchQueue.main.async {
      self.indicatorView.stopAnimating()
    }
  }
}
