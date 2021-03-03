//
//  ClearHistoryRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class ClearHistoryRequestHandler {
	
	class func handle( _ req:NewClearHistoryRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: nil,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.threadId,
								messageType: .CLEAR_HISTORY,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
