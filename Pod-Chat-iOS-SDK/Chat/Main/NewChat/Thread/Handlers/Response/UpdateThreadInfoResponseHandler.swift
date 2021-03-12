//
//  UpdateThreadInfoResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/23/21.
//

import Foundation
import FanapPodAsyncSDK
import Alamofire
import SwiftyJSON

public class UpdateThreadInfoResponseHandler : ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
        guard let data = chatMessage.content?.data(using: .utf8) else {return}
        guard let conversation = try? JSONDecoder().decode(Conversation.self, from: data) else{return}
        callback(.init(result: conversation))
        CacheFactory.write(cacheType: .THREADS([conversation]))
        PSM.shared.save()
    }
    
}
