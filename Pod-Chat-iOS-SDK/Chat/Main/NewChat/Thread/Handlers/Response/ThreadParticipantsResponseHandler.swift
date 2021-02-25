//
//  ThreadParticipantsResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/24/21.
//

import Foundation
class ThreadParticipantsResponseHandler : ResponseHandler{
	
	static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
		guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
		guard let data = chatMessage.content?.data(using: .utf8) else {return}
		guard let conversation = try? JSONDecoder().decode([Participant].self, from: data) else{return}
		callback(.init(result: conversation))
		chat.callbacksManager.removeError(uniqueId: chatMessage.uniqueId)
	}
}
