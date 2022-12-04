//
//  ReactorBaseController.swift
//  COCommonUI
//
//  Created by Taeyoung Son on 2022/12/04.
//

import UIKit

import RxSwift
import ReactorKit
import RxRelay

open class ReactorBaseController<T: ReactorKit.Reactor>: UIViewController, FlexLayoutType, ReactorKit.View, RxBaseType {
    public typealias Reactor = T
    
    public let rootContainer = UIView()
    
    var reload = PublishRelay<Void>()
    public var disposeBag: DisposeBag = .init()
    
    public init(reactor: T? = nil) {
        super.init(nibName: nil, bundle: nil)
        DispatchQueue.main.async {
            self.setup()
            self.reactor = reactor
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        DispatchQueue.main.async {
            self.setup()
        }
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout()
    }
    
    open func setupContainer() {
        self.view.addSubview(self.rootContainer)
    }
    open func setAttrs() {
        self.view.backgroundColor = .white
    }
    open func layout() { }
    open func bind(reactor: T) { }
    open func clearBag() {
        self.disposeBag = .init()
    }
}
