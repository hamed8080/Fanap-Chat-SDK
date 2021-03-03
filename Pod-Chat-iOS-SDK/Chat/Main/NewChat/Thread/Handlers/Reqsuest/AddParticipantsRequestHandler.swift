//
//  AddParticipantsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class AddParticipantsRequestHandler {
	
	class func handle( _ req:[AddParticipantRequest] ,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		guard let firstAddRequest = req.first else {return}
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: firstAddRequest.uniqueId,
								typeCode: firstAddRequest.typeCode ,
								subjectId: firstAddRequest.threadId,
								messageType: .ADD_PARTICIPANT,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	
