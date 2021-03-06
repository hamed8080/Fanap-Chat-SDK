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
					   _ completion: @escaping CompletionType<[Contact]>,
                       _ cacheResponse: CacheResponseType<[Contact]>? = nil,
					   _ uniqueIdResult: UniqueIdResultType = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode,
								messageType: .GET_CONTACTS,
								uniqueIdResult: uniqueIdResult) { response in
			completion(response.result as? [Contact], response.error)
		}
		
		CacheFactory.get(chat:chat ,
						 useCache: cacheResponse != nil,
						 completion: { cacheContacts in
							cacheResponse?( cacheContacts.cacheResponse as? [Contact] , cacheContacts.error)
						 },
						 cacheType: .GET_CASHED_CONTACTS(req))
	}
	
}
