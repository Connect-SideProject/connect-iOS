//
//  TransformType.swift
//  App
//
//  Created by Kim dohyun on 2022/11/10.
//

import RxSwift
import RxCocoa

private var streams: [String: Any] = [:]

protocol TransformType: Codable {
    associatedtype Event
}

extension TransformType {
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

protocol ModelNoneCodableType {
    associatedtype Event
}
extension ModelNoneCodableType {
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
