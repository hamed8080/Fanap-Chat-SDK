//
//  AddBotCommandRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class AddBotCommandRequestHandler {
	
	class func handle( _ req:NewAddBotCommandRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .DEFINE_BOT_COMMAND,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
