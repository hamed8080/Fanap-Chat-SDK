//
//  LeaveThreadRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class LeaveThreadRequestHandler {
	
	class func handle( _ req:NewLeaveThreadRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.threadId,
								messageType: .LEAVE_THREAD,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}

	