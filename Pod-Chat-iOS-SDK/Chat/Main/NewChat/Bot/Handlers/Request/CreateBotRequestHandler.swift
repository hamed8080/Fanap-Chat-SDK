//
//  CreateBotRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class CreateBotRequestHandler {
	
	class func handle( _ req:NewCreateBotRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req.botName,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .CREATE_BOT,
								uniqueIdResult: uniqueIdResult,
								completion: completion,
								plainText:true
		)
	}
}
