//
//  PostCoordinatorDelegate.swift
//  App
//
//  Created by Kim dohyun on 2022/11/22.
//

import UIKit
import COCommonUI


public protocol PostCoordinatorDelegate: AnyObject {
    func didFilterSheetCreate(_ type: BottomSheetType)
}


