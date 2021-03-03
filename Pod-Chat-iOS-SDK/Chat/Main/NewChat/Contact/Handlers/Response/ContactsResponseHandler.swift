//
//  ContactsResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/16/21.
//

import Foundation
class ContactsResponseHandler: ResponseHandler {
    
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        
        
        guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId) else {return}
        guard let data = chatMessage.content?.data(using: .utf8) else {return}
        guard let contacts = try? JSONDecoder().decode([Contact].self, from: data) else{return}
        callback(.init(result: contacts))
        chat.callbacksManager.removeCallback(uniqueId: chatMessage.uniqueId)
        CacheFactory.write(chat: chat, data: contacts, cacheType: .GET_CASHED_CONTACTS)
    }
    
}
