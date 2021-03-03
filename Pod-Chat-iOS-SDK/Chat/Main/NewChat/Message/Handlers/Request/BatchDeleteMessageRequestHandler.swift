//
//  BatchDeleteMessageRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class BatchDeleteMessageRequestHandler {
	
	class func handle( _ req:BatchDeleteMessageRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		req.uniqueIds.forEach { uniqueId in
			chat.callbacksManager.addCallback(uniqueId: uniqueId, callback: completion)
		}
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .DELETE_MESSAGE,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
