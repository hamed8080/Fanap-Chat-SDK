//
//  DeleteMessageRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class DeleteMessageRequestHandler {
	
	class func handle( _ req:NewDeleteMessagerRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.messageId,
								messageType: .DELETE_MESSAGE,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
