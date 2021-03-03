//
//  AllUnreadMessageCountRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class AllUnreadMessageCountRequestHandler {
	
	class func handle( _ req:UnreadMessageCountRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .ALL_UNREAD_MESSAGE_COUNT,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
