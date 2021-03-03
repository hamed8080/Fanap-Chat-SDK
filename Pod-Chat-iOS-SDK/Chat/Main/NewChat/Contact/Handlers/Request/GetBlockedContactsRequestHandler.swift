//
//  GetBlockedContactsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation
import Contacts
class GetBlockedContactsRequestHandler {

	class func handle( _ req:BlockedListRequest ,
					   _ chat:Chat,
					   _ useCache:Bool = false,
					   _ completion: @escaping (ChatResponse)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .GET_BLOCKED,
								uniqueIdResult: uniqueIdResult,
								completion: completion
		)
		
		CacheFactory.get(chat:chat ,
						 useCache: useCache,
						 completion: completion ,
						 cacheType: .GET_CASHED_CONTACTS)
	}
	
}
