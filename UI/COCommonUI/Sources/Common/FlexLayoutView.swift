//
//  FlexLayoutView.swift
//  COCommonUI
//
//  Created by Taeyoung Son on 2022/11/06.
//

import UIKit

import RxSwift

public class FlexLayoutView: UIView, FlexLayoutType, RxBaseType {
    let rootContainer = UIView()
    public var disposeBag: DisposeBag = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layout()
    }
    
    public func setupContainer() {
        self.addSubview(self.rootContainer)
    }
    
    public func setAttrs() { }
    public func layout() { }
    public func clearBag() {
        self.disposeBag = .init()
    }
}
