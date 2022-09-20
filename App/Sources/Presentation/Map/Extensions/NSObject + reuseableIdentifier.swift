//
//  UIICollectionViewCell + reuseableIdentifier.swift
//  connect
//
//  Created by 이건준 on 2022/08/11.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

extension NSObject {
    static var identifier: String {
        return String(describing: self)
    }
}
