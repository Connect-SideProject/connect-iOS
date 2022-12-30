//
//  MapViewController.swift
//  App
//
//  Created by Kim dohyun on 2022/12/30.
//

import UIKit
import ReactorKit


public final class MapViewController: UIViewController {
    
    public typealias Reactor = MapViewReactor
    
    //MARK: Property
    public  var disposeBag: DisposeBag = DisposeBag()
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(#function)
    }
    
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    
}


extension MapViewController: ReactorKit.View {
    
    
    public func bind(reactor: Reactor) {
        
        
    }
}
