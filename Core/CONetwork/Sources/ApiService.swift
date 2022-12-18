//
//  ApiService.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import RxSwift

public protocol ApiService {
  func request<T>(endPoint: EndPoint) -> Observable<T> where T: Decodable
  func requestOutBound<T>(endPoint: EndPoint) -> Observable<T> where T: Decodable
  func upload<T>(endPoint: EndPoint) -> Observable<T> where T: Decodable
}
