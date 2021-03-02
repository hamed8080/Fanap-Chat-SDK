//
//  StopBotResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/24/21.
//

import Foundation
class StopBotResponseHandler: ResponseHandler{
	
	static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
		guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
		guard let botName = chatMessage.content else {return}
		callback(.init(result: botName))
		chat.callbacksManager.removeCallback(uniqueId: chatMessage.uniqueId)
	}
}
