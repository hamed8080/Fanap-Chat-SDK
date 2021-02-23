//
//  ThreadsResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/20/21.
//

import Foundation
class ThreadsResponseHandler: ResponseHandler {


	static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
		guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
		guard let data = chatMessage.content?.data(using: .utf8) else {return}
		guard let conversations = try? JSONDecoder().decode([Conversation].self, from: data) else{return}
		callback(.init(result: conversations))
		chat.callbacksManager.removeError(uniqueId: chatMessage.uniqueId)
	}
}
