//
//  NotSeenContactRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class NotSeenContactRequestHandler{
	class func handle( _ req:NotSeenDurationRequest ,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .GET_NOT_SEEN_DURATION,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
