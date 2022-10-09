//
//  ApiManager.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import CODomain
import RxSwift

public final class ApiManager: ApiService {
  
  public static let shared: ApiManager = ApiManager()
  
  private init() {}
  
  public func request<T>(endPoint: EndPoint) -> Observable<T> where T: Decodable {
    guard let url = endPoint.url else {
      return .empty()
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = endPoint.method.string
    
    if let parameter = endPoint.parameter,
       let jsonData = try? JSONSerialization.data(withJSONObject: parameter) {
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
    print("====================Request====================")
    print("Method: \(endPoint.method.string)")
    print("Header: \(String(describing: endPoint.header))")
    print("URL: \(url.absoluteString)")
    print("Parameter: \(String(describing: endPoint.parameter))")
    print("===============================================")
    
    return Observable<T>.create { observer in
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
        guard let response = response as? HTTPURLResponse else { return }
        
        print("====================Response====================")
        print("StatusCode: \(response.statusCode)")
        print("================================================")
        
        // 회원가입이 필요한 경우.
        if response.statusCode == 204 {
          observer.onError(URLError(.needSignUp))
          return
        }
        
        guard let data = data else {
          observer.onError(URLError(.badServerResponse))
          return
        }
        
        let base = try? JSONDecoder().decode(Base<T>.self, from: data)
        print("====================Response====================")
        print("Data: \(String(describing: base))")
        print("================================================")
        // 에러코드 존재하면 서버에러 발생으로 판단.
        if let _ = base?.errorCode {
          observer.onError(URLError(.badServerResponse))
          return
        }
        
        if let data = base?.data {
          observer.onNext(data)
          observer.on(.completed)
          return
        }
        
        observer.onError(URLError(.dataNotAllowed))
        return
      }
      
      task.resume()
      
      return Disposables.create(with: task.cancel)
    }
  }
  
  public func requestOutBound<T>(endPoint: EndPoint) -> Observable<T> where T : Decodable {
    guard let url = endPoint.url else {
      return .empty()
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = endPoint.method.string
    
    if let parameter = endPoint.parameter,
       let jsonData = try? JSONSerialization.data(withJSONObject: parameter) {
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
    print("====================Request====================")
    print("Method: \(endPoint.method.string)")
    print("Header: \(String(describing: endPoint.header))")
    print("URL: \(url.absoluteString)")
    print("Parameter: \(String(describing: endPoint.parameter))")
    print("===============================================")
    
    return Observable<T>.create { observer in
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
        guard let response = response as? HTTPURLResponse else { return }
        
        print("====================Response====================")
        print("StatusCode: \(response.statusCode)")
        print("================================================")
        // 성공 상태코드가 204 등 200이 아닌 경우 대응
        guard 200 ..< 300 ~= response.statusCode else {
          observer.onError(URLError(.badServerResponse))
          return
        }
        
        guard let data = data else {
          observer.onError(URLError(.badServerResponse))
          return
        }
        
        do {
          let base = try JSONDecoder().decode(T.self, from: data)
          print("====================Response====================")
          print("Data: \(String(describing: base))")
          print("================================================")
          
          observer.onNext(base)
          observer.on(.completed)
          return
        } catch {
          observer.onError(URLError(.dataNotAllowed))
        }
        return
      }
      
      task.resume()
      
      return Disposables.create(with: task.cancel)
    }
  }
}
