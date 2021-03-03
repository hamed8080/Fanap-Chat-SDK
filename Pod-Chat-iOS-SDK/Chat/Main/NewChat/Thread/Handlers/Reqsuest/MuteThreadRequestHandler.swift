//
//  MuteThreadRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class MuteThreadRequestHandler {
	
	class func handle( _ req:NewMuteUnmuteThreadRequest ,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.threadId,
								messageType: .MUTE_THREAD,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	
