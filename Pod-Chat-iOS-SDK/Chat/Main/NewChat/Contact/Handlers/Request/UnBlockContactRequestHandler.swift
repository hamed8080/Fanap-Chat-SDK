//
//  UnBlockContactRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation
import Contacts

class UnBlockContactRequestHandler {

	class func handle( _ req:NewUnBlockRequest ,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
					   ){

		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
						   messageType: .UNBLOCK,
						   uniqueIdResult: uniqueIdResult,
						   completion: completion
		)
	}
	
	
}
