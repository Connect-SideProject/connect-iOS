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

private protocol FlexLayoutType {
    func setup()
    func setupContainer()
    func setAttrs()
    func layout()
}

extension FlexLayoutType {
    func setup() {
        self.setupContainer()
        self.setAttrs()
    }
}

private protocol RxBaseType {
    var disposeBag: DisposeBag { get set }
    func clearBag()
}

class ChatBaseController<T: ReactorKit.Reactor>: UIViewController, FlexLayoutType, ReactorKit.View, RxBaseType {
    typealias Reactor = T
    
    let rootContainer = UIView()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout()
    }
    
    func setupContainer() {
        self.view.addSubview(self.rootContainer)
    }
    func setAttrs() { }
    func layout() { }
    func bind(reactor: T) { }
    func clearBag() {
        self.disposeBag = .init()
    }
}
