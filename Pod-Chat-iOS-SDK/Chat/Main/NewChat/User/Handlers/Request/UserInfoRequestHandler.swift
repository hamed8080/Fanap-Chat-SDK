//
//  UserInfoRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class UserInfoRequestHandler {
	
	class func handle(_ req:UserInfoRequest,
					   _ chat:Chat,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: nil,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .USER_INFO,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
	}
}
