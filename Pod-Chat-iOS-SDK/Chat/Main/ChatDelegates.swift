//
//  ChatDelegates.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 1/30/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//

import Foundation

public protocol ChatErrorDelegate{
    func chatError(errorCode: Int, errorMessage: String, errorResult: Any?)
}

public protocol ChatDelegates: class, ChatErrorDelegate {
    
    func chatConnect()
    func chatDisconnect()
    func chatReconnect()
    func chatReady(withUserInfo: User)
    func chatState(state: AsyncStateType)
    
    func botEvents(model: BotEventModel)
    func contactEvents(model: ContactEventModel)
    func fileUploadEvents(model: FileUploadEventModel)
    func messageEvents(model: MessageEventModel)
    func systemEvents(model: SystemEventModel)
    func threadEvents(model: ThreadEventModel)
    func userEvents(model: UserEventModel)
    
}
