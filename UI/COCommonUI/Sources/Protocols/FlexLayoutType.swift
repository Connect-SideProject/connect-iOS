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

public extension FlexLayoutType where Self: RxBindable {
    func setup() {
        self.setupContainer()
        self.setAttrs()
        self.bind()
    }
}

public protocol RxBaseType {
    var disposeBag: DisposeBag { get set }
    func clearBag()
}

public protocol RxBindable: RxBaseType {
    func bind()
}

public protocol RxDatasourceCell: RxBindable {
    associatedtype SectionItem
    func configure(with item: SectionItem)
}
