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
    
    if let parameter = endPoint.parameter?.toJSONData() {
      request.httpBody = parameter
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
    print("Parameter: \(String(describing: endPoint.parameter?.format(options: [.prettyPrinted])))")
    print("===============================================")
    
    return Observable<T>.create { observer in
      
      let configuration = URLSessionConfiguration.default
      configuration.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
      configuration.connectionProxyDictionary = [AnyHashable: Any]()
      configuration.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
      configuration.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy as String] = "172.31.47.70 "
      configuration.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort as String] = 443

      
      let task = URLSession(configuration: configuration).dataTask(with: request) { data, response, error in
        
        guard let response = response as? HTTPURLResponse else { return }
        
        print("====================Response====================")
        print("StatusCode: \(response.statusCode)")
        
        let headers = response.allHeaderFields.filter {
          $0.key.description == "access-token" || $0.key.description == "refresh-token"
        }
        
        if headers.count != 0 {
          print("Header: \(headers)")
          SessionHeader.shared.update(headers: headers)
        }
        
        // 회원가입이 필요한 경우.
        if response.statusCode == 204 {
          observer.onError(COError.needSignUp)
          print("================================================")
          return
        }
        
        // 토큰 유효시간 만료.
        if response.statusCode == 401 {
          observer.onError(COError.expiredToken)
          print("================================================")
          return
        }
        
        guard let data = data else {
          observer.onError(COError.responseDataIsNil)
          print("================================================")
          return
        }
        
        let base = try? JSONDecoder().decode(Base<T>.self, from: data)
        print("Json: \(data.toJSONString())")
        print("================================================")
        
        print("Data: \(String(describing: base))")
        // 에러코드 존재하면 서버에러 발생으로 판단.
        if let errorCode = base?.errorCode, let message = base?.message {
          observer.onError(COError.message(errorCode, message))
          return
        }
        
        if let data = base?.data {
          observer.onNext(data)
          observer.on(.completed)
          return
        }
        
        observer.onError(COError.dataNotAllowed)
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
          observer.onError(COError.statusCode(response.statusCode))
          return
        }
        
        guard let data = data else {
          observer.onError(COError.responseDataIsNil)
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
          observer.onError(COError.dataNotAllowed)
        }
        return
      }
      
      task.resume()
      
      return Disposables.create(with: task.cancel)
    }
  }
}
