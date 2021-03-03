//
//  ThreadParticipantsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class ThreadParticipantsRequestHandler {
	
	class func handle( _ req:ThreadParticipantsRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.threadId,
								messageType: .THREAD_PARTICIPANTS,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	
