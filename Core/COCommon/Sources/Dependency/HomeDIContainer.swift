//
//  HomeDIContainer.swift
//  COCommon
//
//  Created by Kim dohyun on 2022/10/30.
//

import Foundation


public protocol HomeDIContainer {
    
    associatedtype HomeReactor
    associatedtype HomeViewRepository
    associatedtype HomeViewController
    
    func makeReactor() -> HomeReactor
    func makeRepository() -> HomeViewRepository
    func makeController() -> HomeViewController
    
}
