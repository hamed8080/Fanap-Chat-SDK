//
//  DeliverMessageResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/5/21.
//

import Foundation
class DeliverMessageResponseHandler: ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        
        if let callback =  Chat.sharedInstance.callbacksManager.getDeliverCallback(chatMessage.uniqueId) {
            let message = Message(threadId: chatMessage.subjectId, pushMessageVO: chatMessage.content?.convertToJSON() ?? [:])
            let event = MessageEventModel(type:     MessageEventTypes.MESSAGE_DELIVERY,
                                          message:  message,
                                          threadId: chatMessage.subjectId,
                                          messageId: chatMessage.content?.convertToJSON()["messageId"].int ?? chatMessage.messageId,
                                          senderId: chatMessage.content?.convertToJSON()["participantId"].int ?? chatMessage.participantId,
                                          pinned:   chatMessage.content?.convertToJSON()["pinned"].bool)
            chat.delegate?.messageEvents(model: event)
            
            let messageResponse = DeliverMessageResponse(isDeliver: true, messageId: message.id, threadId: chatMessage.subjectId, message: message, participantId: chatMessage.participantId)
            callback?(messageResponse, nil)
            chat.callbacksManager.removeDeliverCallback(uniqueId: chatMessage.uniqueId)
        }
    }
}
