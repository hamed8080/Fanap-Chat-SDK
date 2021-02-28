//
//  LastSeenResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/28/21.
//

import Foundation
class LastSeenResponseHandler : ResponseHandler{


    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
        guard let data = chatMessage.content?.data(using: .utf8) else {return}
        guard let conversations = try? JSONDecoder().decode(Conversation.self, from: data) else{return}
        callback(.init(result: conversations))
        chat.callbacksManager.removeError(uniqueId: chatMessage.uniqueId)
        let unreadCount = chatMessage.content?.convertToJSON()["unreadCount"].int
        let tUnreadCountUpdateEM = ThreadEventModel(type:           ThreadEventTypes.THREAD_UNREAD_COUNT_UPDATED,
                                                    threadId:       chatMessage.subjectId,
                                                    senderId:       chatMessage.participantId,
                                                    unreadCount:   unreadCount )
        chat.delegate?.threadEvents(model: tUnreadCountUpdateEM)
        let tActivityTimeEM = ThreadEventModel(type:            ThreadEventTypes.THREAD_LAST_ACTIVITY_TIME,
                                               threadId:        chatMessage.subjectId,
                                               unreadCount:     unreadCount)
        chat.delegate?.threadEvents(model: tActivityTimeEM)

        if let count = unreadCount, let threadId = chatMessage.subjectId {
            Chat.cacheDB.updateUnreadCountOnCMConversation(withThreadId: threadId, unreadCount: count, addCount: nil)
        }
    }
}
