//
//  SendStatusPingRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class SendStatusPingRequestHandler {
	
	class func handle(_ req:SendStatusPingRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .STATUS_PING,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
