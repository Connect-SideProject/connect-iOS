//
//  TitleView.swift
//  COCommonUI
//
//  Created by Taeyoung Son on 2022/11/05.
//

import UIKit

import FlexLayout

public class TitleView: FlexLayoutView {
    private let leftBtn = UIButton()
    private let titleLabel = UILabel()
    private let rightBtns = [UIButton(), UIButton()]
    
    public override func setupContainer() {
        super.setupContainer()
        
        self.rootContainer.flex
            .direction(.row)
            .alignItems(.center)
            .define { [weak self] flex in
                guard let self = self else { return }
                
                flex.addItem(self.leftBtn)
                    .marginLeft(28)
                    .width(17).height(20)
                
                flex.addItem(self.titleLabel)
                    .marginLeft(12)
                    .maxWidth(60%)
                
                flex.addItem()
                    .grow(1)
                
                self.rightBtns.enumerated().forEach { offset, btn in
                    flex.addItem(btn)
                        .width(24).height(24)
                        .marginEnd(20)
                }
            }
    }
}
