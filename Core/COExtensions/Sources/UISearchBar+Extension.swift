//
//  UISearchBar+Extension.swift
//  COExtensions
//
//  Created by Kim dohyun on 2022/12/02.
//

import UIKit

import RxSwift
import RxCocoa



public extension Reactive where Base: UISearchBar {
    public var searchButtonTap: ControlEvent<String>  {
        
        let source: Observable<String> = self.base.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(self.base.searchTextField.rx.text.asObservable())
            .flatMap { text -> Observable<String> in
                if let text = text, !text.isEmpty {
                    return .just(text)
                } else {
                    return .empty()
                }
            }.do(onNext: { [weak base = self.base] _ in
                base?.searchTextField.text = nil
            })
        return ControlEvent(events: source)
    }
    
}
