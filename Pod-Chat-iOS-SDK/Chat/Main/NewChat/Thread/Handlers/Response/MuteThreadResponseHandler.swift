//
//  MuteThreadResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/20/21.
//

import Foundation
class MuteThreadResponseHandler: ResponseHandler {


	static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
		guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
		guard let data = chatMessage.content?.data(using: .utf8) else {return}
		guard let threadId = try? JSONDecoder().decode(Int.self, from: data) else{return}
        let resposne = MuteThreadResponse(threadId: threadId)
		callback(.init(result: resposne))
		chat.callbacksManager.removeCallback(uniqueId: chatMessage.uniqueId)
	}
}
