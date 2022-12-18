//
//  ChatListDIContainer.swift
//  ChatDemoApp
//
//  Created by Taeyoung Son on 2022/11/04.
//

import Foundation

public final class ChatDIContainer {
    public init() { }
    
    public func makeChatListVC() -> ChatListController {
        return ChatListController(reactor: .init())
    }
    
    public func makeChatRoomVC() -> ChatRoomController {
        return ChatRoomController(reactor: .init())
    }
}
