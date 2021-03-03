//
//  UnMuteThreadRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class UnMuteThreadRequestHandler {
	
	class func handle( _ request:NewMuteUnmuteThreadRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		
		chat.prepareToSendAsync(req: nil,
								clientSpecificUniqueId: request.uniqueId,
								typeCode: request.typeCode,
								subjectId: request.threadId ,
								messageType: .UNMUTE_THREAD,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	
