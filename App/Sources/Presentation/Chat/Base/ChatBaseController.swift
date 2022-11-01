//
//  ChatBaseController.swift
//  App
//
//  Created by Taeyoung Son on 2022/11/01.
//

import UIKit

import RxSwift
import ReactorKit
import RxRelay

private protocol CodeBaseType {
    func setup()
    func defineLayout()
    func setAttrs()
}

extension CodeBaseType {
    func setup() {
        self.defineLayout()
        self.setAttrs()
    }
}

private protocol RxBaseType {
    var disposeBag: DisposeBag { get set }
    func clearBag()
}

class ChatBaseController<T: ReactorKit.Reactor>: UIViewController, CodeBaseType, ReactorKit.View, RxBaseType {
    typealias Reactor = T
    var reload = PublishRelay<Void>()
    var disposeBag: DisposeBag = .init()
    
    init(reactor: T? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.setup()
        self.reactor = reactor
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func defineLayout() { }
    func setAttrs() { }
    func bind(reactor: T) { }
    func clearBag() {
        self.disposeBag = .init()
    }
}
