//
//  SystemMessageResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/28/21.
//

import Foundation
import FanapPodAsyncSDK

class SystemMessagerResponseHandler : ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        log.verbose("Message of type 'SYSTEM_MESSAGE' revieved", context: "Chat")
        
        let systemEventModel = SystemEventModel(type:       SystemEventTypes.IS_TYPING,
                                                threadId:   chatMessage.subjectId,
                                                user:       chatMessage.content)
        chat.delegate?.systemEvents(model: systemEventModel)
        
    }
    
}
