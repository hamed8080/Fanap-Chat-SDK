//
//  PinMessageRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class UnPinMessageRequestHandler {
	
	class func handle( _ req:NewPinUnpinMessageRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.messageId,
								messageType: .UNPIN_MESSAGE,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
