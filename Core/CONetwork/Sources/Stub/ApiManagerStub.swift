//
//  ApiManagerStub.swift
//  CONetworkApp
//
//  Created by sean on 2022/09/04.
//

import Foundation

import CODomain
import RxSwift

/// Mock test 용 Api Manager
/// Request / Response로 SampleData 내려옴.
public final class ApiManaerStub: ApiService {
  
  // error 방출용 state.
  public enum NetworkState {
    case response(Int)
    case error
  }
  
  public let state: NetworkState
  
  public init(state: NetworkState = .response(200)){
    self.state = state
  }
  
  public func request<T>(endPoint: EndPoint) -> Observable<T> where T: Decodable {
    
    switch state {
    case .response(let statusCode) where statusCode != 200 :
      switch statusCode {
      case 204:
        return .error(COError.needSignUp)
      default:
        break
      }
    case .error:
      return .error(COError.unknown)
    default:
      break
    }
    
    let data = SampleData(
      path: endPoint.path
    ).create()
    print("====================Sample====================")
    print(String(data: data, encoding: .utf8) ?? "")
    print(T.Type.self)
    print("====================Sample====================")
    do {
      let json = try JSONDecoder().decode(T.self, from: data)
      return .just(json)
    } catch let error {
      print("[Decode Error]: \(error.localizedDescription)")
      return .error(COError.cannotDecodeJsonData)
    }
  }
  
  public func requestOutBound<T>(endPoint: EndPoint) -> RxSwift.Observable<T> where T : Decodable {
    return .empty()
  }
  
  public func upload<T>(endPoint: EndPoint) -> Observable<T> where T : Decodable {
    return .empty()
  }
}
