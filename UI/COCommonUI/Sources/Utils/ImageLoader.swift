//
//  ImageLoader.swift
//  connectUITests
//
//  Created by sean on 2022/06/29.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation
import UIKit

public protocol ImageLoadable {
  func fetch(url: URL) async throws -> UIImage
}

public actor ImageLoader: ImageLoadable {
  
  private let cache: URLCache
  
  public init(cache: URLCache = .shared) {
    self.cache = cache
  }
  
  public func fetch(url: URL) async throws -> UIImage {
    
    let request = URLRequest(url: url)
    
    if let cachedResponse = cache.cachedResponse(for: request) {
      let image = UIImage(data: cachedResponse.data)!
      return image
    }
    
    let task: Task<UIImage, Error> = Task {
      let (imageData, response) = try await URLSession.shared.data(for: request)
      let image = UIImage(data: imageData)!
      cache.storeCachedResponse(.init(response: response, data: imageData), for: request)
      return image
    }
    
    let image = try await task.value
    return image
  }
}
