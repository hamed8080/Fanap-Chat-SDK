//
//  CreateThreadResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/22/21.
//

import Foundation
class CreateThreadResponseHandler: ResponseHandler {
	
	static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
		guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
		guard let data = chatMessage.content?.data(using: .utf8) else {return}
		guard let newThread = try? JSONDecoder().decode(Conversation.self, from: data) else{return}
		callback(.init(result: newThread))
		chat.callbacksManager.removeCallback(uniqueId: chatMessage.uniqueId)
	}
}
