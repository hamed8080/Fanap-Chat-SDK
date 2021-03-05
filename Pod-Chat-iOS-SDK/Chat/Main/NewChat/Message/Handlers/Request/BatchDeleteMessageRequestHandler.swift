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
					   _ completion: @escaping CompletionType<DeleteMessage>,
					   _ uniqueIdResult: UniqueIdResultType = nil
	){
		req.uniqueIds.forEach { uniqueId in
			chat.callbacksManager.addCallback(uniqueId: uniqueId, callback: { response in
                completion(response.result as? DeleteMessage ,response.error)
            })
		}
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .DELETE_MESSAGE,
                                uniqueIdResult: uniqueIdResult){ response in
            completion(response.result as? DeleteMessage , response.error)
        }
	}
}
