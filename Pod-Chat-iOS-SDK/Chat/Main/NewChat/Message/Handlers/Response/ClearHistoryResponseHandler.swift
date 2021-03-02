//
//  ClearHistoryResponseHandler.swift
//  Alamofire
//
//  Created by Hamed Hosseini on 2/26/21.
//

import Foundation

class ClearHistoryResponseHandler: ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
        guard let data = chatMessage.content?.data(using: .utf8) else {return}
        guard let threadId = try? JSONDecoder().decode(Int.self, from: data) else{return}
        callback(.init(result: threadId))
        chat.callbacksManager.removeCallback(uniqueId: chatMessage.uniqueId)
    }
}

