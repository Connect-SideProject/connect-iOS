//
//  FlexLayoutView.swift
//  COCommonUI
//
//  Created by Taeyoung Son on 2022/11/06.
//

import UIKit

import RxSwift

open class FlexLayoutView: UIView, FlexLayoutType, RxBaseType {
    public let rootContainer = UIView()
    public var disposeBag: DisposeBag = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layout()
    }
    
    open func setupContainer() {
        self.addSubview(self.rootContainer)
    }
    
    open func setAttrs() { }
    open func layout() { }
    open func clearBag() {
        self.disposeBag = .init()
    }
}
