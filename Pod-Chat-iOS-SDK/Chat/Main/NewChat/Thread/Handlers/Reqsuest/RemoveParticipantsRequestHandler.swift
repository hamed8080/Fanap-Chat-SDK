//
//  RemoveParticipantsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class RemoveParticipantsRequestHandler {
	
	class func handle( _ req : NewRemoveParticipantsRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.threadId,
								messageType: .REMOVE_PARTICIPANT,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	
