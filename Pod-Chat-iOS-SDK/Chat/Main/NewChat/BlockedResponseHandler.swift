//
//  BlockedResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/16/21.
//

import Foundation
class BlockedResponseHandler: ResponseHandler {
    
    
    static func handle(_ chat: NewChat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        
        
        guard let callback = chat.callbacksManager.callbacks[chatMessage.uniqueId] else {return}
        guard let data = chatMessage.content?.data(using: .utf8) else {return}
        guard let blockedContacts = try? JSONDecoder().decode([BlockedUser].self, from: data) else{return}
        callback(.init(result: blockedContacts))
        chat.callbacksManager.removeError(uniqueId: chatMessage.uniqueId)
    }
    
}
