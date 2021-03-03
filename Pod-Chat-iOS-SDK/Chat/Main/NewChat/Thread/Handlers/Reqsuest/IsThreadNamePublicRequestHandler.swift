//
//  IsThreadNamePublicRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class IsThreadNamePublicRequestHandler {
	
	class func handle( _ req:IsThreadNamePublicRequest ,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .IS_NAME_AVAILABLE,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	
