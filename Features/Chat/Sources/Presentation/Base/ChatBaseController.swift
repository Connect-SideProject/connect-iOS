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
import COCommonUI

public class ChatBaseController<T: ReactorKit.Reactor>: UIViewController, FlexLayoutType, ReactorKit.View, RxBaseType {
    public typealias Reactor = T
    
    let rootContainer = UIView()
    
    var reload = PublishRelay<Void>()
    public var disposeBag: DisposeBag = .init()
    
    init(reactor: T? = nil) {
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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout()
    }
    
    public func setupContainer() {
        self.view.addSubview(self.rootContainer)
    }
    public func setAttrs() {
        self.view.backgroundColor = .white
    }
    public func layout() { }
    public func bind(reactor: T) { }
    public func clearBag() {
        self.disposeBag = .init()
    }
}
