//
//  BaseView.swift
//  connect
//
//  Created by Kim dohyun on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import RxSwift


class BaseView: UIView {
    
    //MARK: Property
    lazy private(set) var className: String =  {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    deinit {
        print("Class : \(self.className)")
    }
    
    //MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
