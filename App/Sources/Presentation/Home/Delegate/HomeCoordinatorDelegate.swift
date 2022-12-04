//
//  HomeCoordinatorDelegate.swift
//  App
//
//  Created by Kim dohyun on 2022/11/15.
//

import Foundation

public protocol HomeCoordinatorDelegate: AnyObject {
    func didTapToPostListCreate()
    func didTapToSearchCreate()
    func didTapToNoticeCreate()
}
