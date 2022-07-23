//
//  ApiManager.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import RxSwift

class ApiManager: ApiService {
  
  static let shared: ApiManager = ApiManager()
  
  private init() {}
  
  func request<T>(endPoint: EndPoint) -> Observable<T> where T: Decodable {
    guard let url = endPoint.url else {
      return .empty()
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = endPoint.method.string

    if let jsonData = try? JSONSerialization.data(withJSONObject: endPoint.parameter) {
      request.httpBody = jsonData
    }
    
    if let header = endPoint.header {
      let _ = header.map {
        let key = $0.key
        let value = $0.value
        request.addValue(
          value,
          forHTTPHeaderField: key
        )
      }
    }
    
    return Observable<T>.create { observer in
      let _ = URLSession.shared.rx.response(request: request)
        .flatMap { response, data -> Observable<T> in
          
          // 성공 상태코드가 204 등 200이 아닌 경우 대응
          guard 200 ..< 300 ~= response.statusCode else {
            observer.onError(URLError(.badServerResponse))
            return .empty()
          }
          
          let base = try? JSONDecoder().decode(Base<T>.self, from: data)
          
          if let message = base?.message, !message.isEmpty {
            observer.onError(URLError(.badServerResponse))
            return .empty()
          }
          
          if let data = base?.data {
            observer.onNext(data)
            return .empty()
          }
          
          observer.onError(URLError(.dataNotAllowed))
          return .empty()
        }
      
      return Disposables.create()
    }
  }
}
