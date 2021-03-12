//
//  SeenMessageResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/5/21.
//

import Foundation
class SeenMessageResponseHandler: ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        if let callback =  Chat.sharedInstance.callbacksManager.getSeenCallback(chatMessage.uniqueId) {
            let message = Message(threadId: chatMessage.subjectId, pushMessageVO: chatMessage.content?.convertToJSON() ?? [:])
            let event =  MessageEventModel(type:     MessageEventTypes.MESSAGE_SEEN,
                                           message:  message,
                                           threadId: chatMessage.subjectId,
                                           messageId: chatMessage.content?.convertToJSON()["messageId"].int ?? chatMessage.messageId,
                                           senderId: chatMessage.content?.convertToJSON()["participantId"].int ?? chatMessage.participantId,
                                           pinned:   chatMessage.content?.convertToJSON()["pinned"].bool)
            
            chat.delegate?.messageEvents(model: event)
            let messageResponse = SeenMessageResponse(isSeen: true, messageId: message.id, threadId: chatMessage.subjectId, message: message, participantId: chatMessage.participantId)
            callback?(messageResponse, nil)
            chat.callbacksManager.removeSeenCallback(uniqueId: chatMessage.uniqueId)
        }
    }
    
}
