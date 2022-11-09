//
//  TransformType.swift
//  App
//
//  Created by Kim dohyun on 2022/11/10.
//

import RxSwift
import RxCocoa

protocol TransformType {
    associatedtype Event
}

extension TransformType {
    static var event: PublishSubject<Event> {
        let stream = PublishSubject<Event>()
        return stream
    }
}
