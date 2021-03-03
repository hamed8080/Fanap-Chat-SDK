//
//  SyncContactsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation
import Contacts
class GetContactsRequestHandler {
	
	class func handle( _ req:ContactsRequest ,
					   _ chat:Chat,
					   _ useCache:Bool = false,
					   _ completion: @escaping ([Contact]? ,[Contact]? , ChatError?)->() ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode,
								messageType: .GET_CONTACTS,
								uniqueIdResult: uniqueIdResult) { response in
			completion(response.result as? [Contact], nil, response.error)
		}
		
		
		CacheFactory.get(chat:chat ,
						 useCache: useCache,
						 completion: { cacheContacts in
							completion(nil, cacheContacts.cacheResponse as? [Contact] ,nil)
						 },
						 cacheType: .GET_CASHED_CONTACTS)
	}
	
}
