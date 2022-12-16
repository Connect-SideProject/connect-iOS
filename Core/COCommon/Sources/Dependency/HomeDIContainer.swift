//
//  HomeDIContainer.swift
//  COCommon
//
//  Created by Kim dohyun on 2022/10/30.
//

import Foundation

@objc public protocol ChildrenContainer {
    typealias ChildrenDependency = AnyObject
    typealias ChildrenController = AnyObject
    
    @objc optional func makeChildrenDependency() -> ChildrenDependency
    @objc optional func makeChildrenController() -> ChildrenController
}



public protocol HomeDIContainer: ChildrenContainer {
    
    associatedtype HomeReactor
    associatedtype HomeViewRepository
    associatedtype HomeViewController
    
    
    func makeReactor() -> HomeReactor
    func makeRepository() -> HomeViewRepository
    func makeController() -> HomeViewController
    
}
