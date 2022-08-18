//
//  ApiManagerStub.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import RxSwift

/// Mock test 용 api manager.
/// Request / Response로 SampleData 내려옴.
final class ApiManagerStub: ApiService {

  // error 방출용 state.
  enum NetworkState {
    case response(Int)
    case error
  }

  private let stubNetworkState: NetworkState

  init(state: NetworkState = .response(200)) {
    self.stubNetworkState = state
  }

  func request<T>(endPoint: EndPoint) -> Observable<T> where T: Decodable {
    
    if case .error = stubNetworkState {
      return .error(URLError(.unknown))
    }
    
//    let data = SampleData(
//      path: endPoint.path
//    ).create()
    
//    if let decode = try? JSONDecoder().decode(T.self, from: data) {
//      return .just(decode)
//    }
    
    return .empty()
  }
}
