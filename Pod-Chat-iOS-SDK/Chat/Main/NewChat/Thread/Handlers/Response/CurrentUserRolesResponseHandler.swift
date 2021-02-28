//
//  CurrentUserRolesResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/20/21.
//

import Foundation
class CurrentUserRolesResponseHandler: ResponseHandler {


	static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
		guard let callback = chat.callbacksManager.getCallBack(chatMessage.uniqueId)else {return}
		guard let data = chatMessage.content?.data(using: .utf8) else {return}
		guard let userRoles = try? JSONDecoder().decode([Roles].self, from: data) else{return}
		callback(.init(result: userRoles))
		chat.callbacksManager.removeError(uniqueId: chatMessage.uniqueId)
	}
}