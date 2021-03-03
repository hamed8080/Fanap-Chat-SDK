//
//  SeenRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class SeenRequestHandler {
	
	class func handle( _ req:MessageSeenRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req.messageId,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .SEEN,
								uniqueIdResult: uniqueIdResult,
								completion: completion,
								plainText:true
		)
	}
}
