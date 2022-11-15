//
//  FlexBaseType.swift
//  COCommonUI
//
//  Created by Taeyoung Son on 2022/11/05.
//

import UIKit

import RxSwift

public protocol FlexLayoutType {
    func setup()
    func setupContainer()
    func setAttrs()
    func layout()
}

public extension FlexLayoutType {
    func setup() {
        self.setupContainer()
        self.setAttrs()
    }
}

public protocol RxBaseType {
    var disposeBag: DisposeBag { get set }
    func clearBag()
}
