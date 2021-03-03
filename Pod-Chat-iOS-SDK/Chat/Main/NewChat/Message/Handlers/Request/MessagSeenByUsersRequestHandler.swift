//
//  MessagSeenByUsersRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class MessagSeenByUsersRequestHandler {
	
	class func handle( _ req:MessageSeenByUsersRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .GET_MESSAGE_SEEN_PARTICIPANTS,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
