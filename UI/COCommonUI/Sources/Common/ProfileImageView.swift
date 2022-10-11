//
//  ProfileImageView.swift
//  connect
//
//  Created by sean on 2022/06/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout

/// 프로필 원형 이미지 사이즈.
public enum ProfileImageSize {
  case large, medium, small
  
  public var value: CGSize {
    switch self {
    case .large:
      return .init(width: 200, height: 200)
    case .medium:
      return .init(width: 80, height: 80)
    case .small:
      return .init(width: 50, height: 50)
    }
  }
}

/// 프로필 원형 이미지 뷰.
public final class ProfileImageView: UIView {
  
  private let imageView = IndicatorImageView()
  
  private let flexContainerView = UIView()
  
  private let imageLoader: ImageLoadable
  private let imageSize: ProfileImageSize
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    flexContainerView.pin.layout()
    flexContainerView.flex.layout()
  }
  
  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    layer.cornerRadius = bounds.size.width / 2
    layer.masksToBounds = true
  }
  /**
   프로필 원형 이미지 뷰 생성자.
   
   - Parameter imageLoader: 이미지 다운로드를 위한 Loader(ImageLoadable).
   - Parameter imageSize: 프로필 원형 이미지 사이즈.
   
   */
  public init(
    imageLoader: ImageLoadable = ImageLoader(),
    imageSize: ProfileImageSize = .medium
  ) {
    self.imageLoader = imageLoader
    self.imageSize = imageSize
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(flexContainerView)
    
    flexContainerView
      .flex
      .define { flex in
        flex.addItem(imageView)
    }
  }
  
  /**
   원격 이미지 주소로부터 이미지를 다운로드 받아 이미지를 설정.
   
   이미지 다운로드를 위한 imageLoader 내부적으로 async 처리가 되어있어 async 명시 함.
   
   - Parameter url: 원격 이미지 주소.
   
   */
  public func setImage(url: URL) async {
    do {
      let image = try await imageLoader.fetch(url: url)
      imageView.image = image
      
    } catch let error {
      print(error)
      imageView.stopLoading()
    }
  }
}
