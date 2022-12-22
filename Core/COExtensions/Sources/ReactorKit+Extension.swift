//
//  ReactorKit+Extension.swift
//  COExtensions
//
//  Created by sean on 2022/09/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

public protocol ErrorHandlerable where Self: Reactor {
  var errorHandler: (_ error: Error) -> Observable<Mutation> { get }
}


private var streams: [String: Any] = [:]

public protocol TransformType: Codable {
    associatedtype Event
}

public extension TransformType {
    static var event: PublishSubject<Event> {
        let key = String(describing: self)
        if let stream = streams[key] as? PublishSubject<Event> {
            return stream
        }
        let stream = PublishSubject<Event>()
        streams[key] = stream
        return stream
    }
}

public protocol ModelNoneCodableType {
    associatedtype Event
}
public extension ModelNoneCodableType {
    static var event: PublishSubject<Event> {
        let key = String(describing: self)
        if let stream = streams[key] as? PublishSubject<Event> {
            return stream
        }
        let stream = PublishSubject<Event>()
        streams[key] = stream
        return stream
    }
}

