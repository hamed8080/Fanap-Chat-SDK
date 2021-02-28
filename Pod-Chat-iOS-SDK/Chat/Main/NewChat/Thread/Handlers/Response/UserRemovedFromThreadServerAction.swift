//
//  UserRemovedFromThreadServerAction.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/28/21.
//

import Foundation
class UserRemovedFromThreadServerAction: ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        guard let threadId = chatMessage.subjectId else {return}
        let tRemoveFromThreadEM = ThreadEventModel(type: .THREAD_REMOVED_FROM, threadId: threadId)
        chat.delegate?.threadEvents(model: tRemoveFromThreadEM)
        
//        if createChatModel.enableCache {
//            Chat.cacheDB.deleteThreads(withThreadIds: [threadId])
//        }
    }
}
