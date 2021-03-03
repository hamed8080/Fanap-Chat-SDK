//
//  PinThreadRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class PinThreadRequestHandler {
	
	class func handle( _ request:NewPinUnpinThreadRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		
		chat.prepareToSendAsync(req: nil,
								clientSpecificUniqueId: request.uniqueId,
								typeCode: request.typeCode,
								subjectId: request.threadId ,
								messageType: .PIN_THREAD,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	
