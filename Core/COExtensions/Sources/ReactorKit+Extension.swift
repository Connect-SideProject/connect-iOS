//
//  ReactorKit+Extension.swift
//  COExtensions
//
//  Created by sean on 2022/09/24.
//

import Foundation

import ReactorKit

public protocol ErrorHandlerable where Self: Reactor {
  var errorHandler: (_ error: Error) -> Observable<Mutation> { get }
}
