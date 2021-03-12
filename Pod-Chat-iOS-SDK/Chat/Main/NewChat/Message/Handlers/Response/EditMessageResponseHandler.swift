//
//  EditMessageResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/5/21.
//

import Foundation
class EditMessageResponseHandler: ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        guard let callback =  Chat.sharedInstance.callbacksManager.getCallBack(chatMessage.uniqueId) else {return}
        
        let message = Message(threadId: chatMessage.subjectId, pushMessageVO: chatMessage.content?.convertToJSON() ?? [:])
        let event = MessageEventModel(type: .MESSAGE_SEND,
                                      message: message,
                                      threadId: chatMessage.subjectId,
                                      messageId: chatMessage.messageId,
                                      senderId: nil,
                                      pinned: nil)
        chat.delegate?.messageEvents(model: event)
        callback(.init(result:message))
        CacheFactory.write(cacheType: .DELETE_EDIT_MESSAGE_QUEUE(message))
        CacheFactory.write(cacheType: .MESSAGE(message))
        PSM.shared.save()
        chat.callbacksManager.removeSentCallback(uniqueId: chatMessage.uniqueId)
    }
}
