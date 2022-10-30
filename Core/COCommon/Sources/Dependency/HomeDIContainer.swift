//
//  HomeDIContainer.swift
//  COCommon
//
//  Created by Kim dohyun on 2022/10/30.
//

import Foundation


public protocol HomeDIConainer {
    
    associatedtype HomeReactor
    associatedtype HomeViewRepository
    associatedtype HomeViewController
    
    func makeHomeReactor() -> HomeReactor
    func makeHomeRepository() -> HomeViewRepository
    func makeHomeController() -> HomeViewController
    
}
