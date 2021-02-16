//
//  ContactNotSeenDurationHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/16/21.
//

import Foundation
class ContactNotSeenDurationHandler: ResponseHandler {
    
    
    static func handle(_ chat: NewChat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        
        
        guard let callback = chat.callbacksManager.callbacks[chatMessage.uniqueId] else {return}
        guard let data = chatMessage.content?.data(using: .utf8) else {return}
        guard let contacts = try? JSONDecoder().decode(ContactNotSeenDurationRespoonse.self, from: data) else{return}
        callback(.init(result: contacts))
        chat.callbacksManager.removeError(uniqueId: chatMessage.uniqueId)
    }
    
}
