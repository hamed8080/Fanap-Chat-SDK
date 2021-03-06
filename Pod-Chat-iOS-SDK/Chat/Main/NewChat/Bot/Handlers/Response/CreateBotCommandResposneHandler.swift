//
//  CreateBotCommandResposneHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/24/21.
//

import Foundation
class CreateBotCommandResposneHandler: ResponseHandler{
	
	static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
		guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
		guard let data = chatMessage.content?.data(using: .utf8) else {return}
		guard let botInfo = try? JSONDecoder().decode(BotInfo.self, from: data) else{return}
		callback(.init(result: botInfo))
		chat.callbacksManager.removeCallback(uniqueId: chatMessage.uniqueId)
	}
}
