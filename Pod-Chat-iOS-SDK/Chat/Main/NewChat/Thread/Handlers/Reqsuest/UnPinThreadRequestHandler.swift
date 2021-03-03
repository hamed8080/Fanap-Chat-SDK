//
//  UnPinThreadRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class UnPinThreadRequestHandler {
	
	class func handle( _ request:NewPinUnpinThreadRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		
		chat.prepareToSendAsync(req: nil,
								clientSpecificUniqueId: request.uniqueId,
								typeCode: request.typeCode,
								subjectId: request.threadId ,
								messageType: .UNPIN_THREAD,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	
