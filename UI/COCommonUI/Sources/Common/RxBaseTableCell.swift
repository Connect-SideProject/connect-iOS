//
//  RxBaseTableCell.swift
//  Chat
//
//  Created by Taeyoung Son on 2022/11/17.
//

import UIKit

import RxSwift

open class RxBaseTableCell<SectionItem>: UITableViewCell, FlexLayoutType, RxDatasourceCell {
    
    public var disposeBag: DisposeBag = .init()
    
    public var rootContainer = UIView()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layout()
    }
    
    open func setupContainer() {
        self.contentView.addSubview(self.rootContainer)
    }
    open func layout() { }
    open func setAttrs() { }
    open func bind() { }
    open func clearBag() {
        self.disposeBag = .init()
    }
    open func configure(with item: SectionItem) { }
}
