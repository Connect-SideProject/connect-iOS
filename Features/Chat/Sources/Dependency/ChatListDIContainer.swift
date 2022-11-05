//
//  ChatListDIContainer.swift
//  ChatDemoApp
//
//  Created by Taeyoung Son on 2022/11/04.
//

import Foundation

public final class ChatListDIContainer {
    public init() { }
    
    public func makeVC() -> ChatListController {
        return ChatListController(reactor: .init())
    }
}
