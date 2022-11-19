//
//  PaddingLabel.swift
//  COCommonUI
//
//  Created by Taeyoung Son on 2022/11/20.
//

import UIKit

public class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

    public convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.padding))
    }

    public override var intrinsicContentSize: CGSize {
        let insets = self.padding
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right
        return contentSize
    }
}
