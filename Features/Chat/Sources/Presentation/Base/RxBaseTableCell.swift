//
//  RxBaseTableCell.swift
//  Chat
//
//  Created by Taeyoung Son on 2022/11/17.
//

import UIKit

import RxSwift
import COCommonUI

protocol RxDatasourceCell: RxBindable {
    associatedtype SectionItem
    func configure(with item: SectionItem)
}

class RxBaseTableCell<SectionItem>: UITableViewCell, FlexLayoutType, RxDatasourceCell, RxBindable {
    
    var disposeBag: DisposeBag = .init()
    
    var rootContainer = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layout()
    }
    
    func setupContainer() {
        self.contentView.addSubview(self.rootContainer)
    }
    func layout() { }
    func setAttrs() { }
    func bind() { }
    func clearBag() {
        self.disposeBag = .init()
    }
    func configure(with item: SectionItem) { }
}
