//
//  UpdateChatProfileRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class UpdateChatProfileRequestHandler {
	
	class func handle(_ req:NewUpdateChatProfile,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .SET_PROFILE,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
