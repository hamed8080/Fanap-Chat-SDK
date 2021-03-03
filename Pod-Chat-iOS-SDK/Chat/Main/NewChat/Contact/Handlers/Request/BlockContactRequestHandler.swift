//
//  BlockContactRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation
import Contacts

class BlockContactRequestHandler {

	class func handle( _ req:NewBlockRequest ,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
					   ){

		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
						   messageType: .BLOCK,
						   uniqueIdResult: uniqueIdResult,
						   completion: completion
		)
	}
	
	
}
