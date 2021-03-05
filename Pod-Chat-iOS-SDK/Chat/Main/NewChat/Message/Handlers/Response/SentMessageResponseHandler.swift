//
//  SentMessageResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/5/21.
//

import Foundation
class SentMessageResponseHandler: ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {

//        if enableCache {
//            if let _ = message.subjectId {
//                // the response from server is come correctly, so this message will be removed from wait queue
//                Chat.cacheDB.deleteWaitTextMessage(uniqueId: message.uniqueId)
//                Chat.cacheDB.deleteWaitFileMessage(uniqueId: message.uniqueId)
//                Chat.cacheDB.deleteWaitForwardMessage(uniqueId: message.uniqueId)
//            }
//        }
        if let callback =  Chat.sharedInstance.callbacksManager.getSentCallBack(chatMessage.uniqueId) {
            let message = Message(threadId: chatMessage.subjectId, pushMessageVO: chatMessage.content?.convertToJSON() ?? [:])
            let event = MessageEventModel(type: .MESSAGE_SEND, message: message, threadId: chatMessage.subjectId, messageId: chatMessage.messageId, senderId: nil, pinned: nil)
            chat.delegate?.messageEvents(model: event)
            
            let messageResponse = SentMessageResponse(isSent: true, messageId: message.id, threadId: chatMessage.subjectId, message: message, participantId: chatMessage.participantId)
            callback?(messageResponse, nil)
            chat.callbacksManager.removeSentCallback(uniqueId: chatMessage.uniqueId)
        }
        
    }
    
    
   
}
