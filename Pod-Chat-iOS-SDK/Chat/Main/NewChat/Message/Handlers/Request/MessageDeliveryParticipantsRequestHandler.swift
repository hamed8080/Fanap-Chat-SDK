//
//  MessageDeliveryParticipantsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class MessageDeliveryParticipantsRequestHandler {
	
	class func handle( _ req:MessageDeliveredUsersRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .GET_MESSAGE_DELEVERY_PARTICIPANTS,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
