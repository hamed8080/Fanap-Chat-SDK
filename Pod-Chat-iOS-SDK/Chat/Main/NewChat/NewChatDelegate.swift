//
//  NewChatDelegate.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/16/21.
//

import Foundation

public protocol NewChatDelegate: class {
    
    func chatConnect()
    func chatDisconnect()
    func chatReconnect()
    func chatReady(withUserInfo: User)
    func chatState(state: AsyncStateType)
    
    func chatBotEvents(model: BotEventModel)
    func chatContactEvents(model: ContactEventModel)
    func chatFileUploadEvents(model: FileUploadEventModel)
    func chatMessageEvents(model: MessageEventModel)
    func chatSystemEvents(model: SystemEventModel)
    func chatThreadEvents(model: ThreadEventModel)
    func chatUserEvents(model: UserEventModel)
    
    func chatError(code: Int, message: String, content: String?)
    
}
