//
//  CreateThreadWithMessageRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class CreateThreadWithMessageRequestHandler {
	
	class func handle( _ req:CreateThreadWithMessage,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .CREATE_THREAD,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	
