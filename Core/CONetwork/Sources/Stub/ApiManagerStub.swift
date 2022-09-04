//
//  ApiManagerStub.swift
//  CONetworkApp
//
//  Created by sean on 2022/09/04.
//

import Foundation

import RxSwift

/// Mock test 용 Api Manager
/// Request / Response로 SampleData 내려옴.
public final class ApiManaerStub: ApiService {
  
  // error 방출용 state.
  public enum NetworkState {
    case response(Int)
    case error
  }
  
  private let stubNetworkState: NetworkState
  
  public init(state: NetworkState = .response(200)) {
    self.stubNetworkState = state
  }
  
  public func request<T>(endPoint: EndPoint) -> Observable<T> where T: Decodable {
    
    if case .error = stubNetworkState {
      return .error(URLError(.unknown))
    }
    
    let data = SampleData(
      path: endPoint.path
    ).create()
    
    if let decode = try? JSONDecoder().decode(T.self, from: data) {
      return .just(decode)
    }
    
    return .empty()
  }
}
