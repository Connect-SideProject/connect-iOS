//
//  TitleView.swift
//  COCommonUI
//
//  Created by Taeyoung Son on 2022/11/05.
//

import UIKit

import FlexLayout

public final class TitleView: FlexLayoutView {
    private let leftBtn = UIButton()
    private let titleLabel = UILabel()
    private let rightInnerBtn = UIButton()
    private let rightOuterBtn = UIButton()
    private let separatorView = UIView()
    private var rightBtns: [UIButton] {
        [self.rightInnerBtn, self.rightOuterBtn]
    }
    private var allBtns: [UIButton] {
        [self.leftBtn, self.rightInnerBtn, self.rightOuterBtn]
    }
    
    private var leftBtnAction: ButtonAction?
    private var rightInnerBtnAction: ButtonAction?
    private var rightOuterBtnAction: ButtonAction?
    
    public override func setupContainer() {
        super.setupContainer()
        
        self.rootContainer.flex.define { flex in
            flex.addItem()
                .direction(.row)
                .alignItems(.center)
                .grow(1)
                .define { flex in
                    flex.addItem(self.leftBtn)
                        .marginLeft(28)
                        .width(17).height(20)
                    
                    flex.addItem(self.titleLabel)
                        .marginLeft(20)
                        .maxWidth(60%)
                    
                    flex.addItem()
                        .grow(1)
                    
                    self.rightBtns.enumerated().forEach { offset, btn in
                        flex.addItem(btn)
                            .width(24).height(24)
                            .marginEnd(20)
                    }
                }
            
            flex.addItem(self.separatorView)
                .height(1)
        }
    }
    
    public override func layout() {
        self.rootContainer.pin.all()
        self.rootContainer.flex.layout()
    }
    
    public override func setAttrs() {
        self.titleLabel.font = .semiBold(size: 16)
        self.titleLabel.textColor = .hex3A3A3A
        self.allBtns.forEach { $0.flex.display(.none) }
        self.separatorView.backgroundColor = .hexEDEDED
    }
}

public extension TitleView {
    typealias ButtonAction = (() -> Void)
    
    enum BtnType {
        case back, pin, star, alert, search, menu
        
        var image: UIImage? {
            var img: UIImage?
            switch self {
            case .back: img = COCommonUIAsset.icTitleBack.image
            case .pin: img = COCommonUIAsset.icTitlePin.image
            case .star: img = COCommonUIAsset.icTitleStar.image
            case .alert: img = COCommonUIAsset.icTitleAlert.image
            case .search: img = COCommonUIAsset.icTitleSearch.image
            case .menu: img = COCommonUIAsset.icTitleKebabMenu.image
            }
            return img
        }
    }
}

public extension TitleView {
    @discardableResult func set(title: String) -> Self {
        self.titleLabel.text = title
        return self
    }
    
    @discardableResult func setLeftBtn(type: BtnType, action: ButtonAction? = nil) -> Self {
        self.leftBtn.flex.display(.flex)
        self.leftBtn.setImage(type.image, for: .normal)
        self.leftBtnAction = action
        return self
    }
    
    @discardableResult func setRightInnerBtn(type: BtnType, action: ButtonAction? = nil) -> Self {
        self.rightInnerBtn.flex.display(.flex)
        self.rightInnerBtn.setImage(type.image, for: .normal)
        self.rightInnerBtnAction = action
        return self
    }
    
    @discardableResult func setRightOuterBtn(type: BtnType, action: ButtonAction? = nil) -> Self {
        self.rightOuterBtn.flex.display(.flex)
        self.rightOuterBtn.setImage(type.image, for: .normal)
        self.rightOuterBtnAction = action
        return self
    }
}
