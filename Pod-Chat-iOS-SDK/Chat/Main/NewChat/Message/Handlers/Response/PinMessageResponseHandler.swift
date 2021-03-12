//
//  PinMessageResponseHandler.swift
//  Alamofire
//
//  Created by Hamed Hosseini on 2/26/21.
//

import Foundation

class PinMessageResponseHandler: ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
        guard let data = chatMessage.content?.data(using: .utf8) else {return}
        guard let pinResponse = try? JSONDecoder().decode(PinUnpinMessage.self, from: data) else{return}
        callback(.init(result: pinResponse))
        CacheFactory.write(cacheType: .PIN_MESSAGE(pinResponse, chatMessage.subjectId))
        PSM.shared.save()
        chat.callbacksManager.removeCallback(uniqueId: chatMessage.uniqueId)
    }
}

