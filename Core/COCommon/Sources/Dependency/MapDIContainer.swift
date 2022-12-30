//
//  MapDIContainer.swift
//  COCommon
//
//  Created by Kim dohyun on 2022/12/30.
//

import Foundation


public protocol MapDIContainer {
    
    associatedtype Reactor
    associatedtype Repository
    associatedtype Controller
    
    func makeReactor() -> Reactor
    func makeRepository() -> Repository
    func makeController() -> Controller
    
}
