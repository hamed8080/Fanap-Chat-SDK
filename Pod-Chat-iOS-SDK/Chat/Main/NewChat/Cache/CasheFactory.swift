//
//  CasheFactory.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation
class CacheFactory {
	
	enum ReadCacheType {
		case GET_CASHED_CONTACTS(_ req:ContactsRequest?)
		case GET_THREADS(_ req:ThreadsRequest)
		case GET_BLOCKED_USERS
	}
	
	enum WriteCacheType {
		case CASHE_CONTACTS(_ contacts:[Contact])
		case THREADS(_ threads:[Conversation])
		case GET_BLOCKED_USERS
	}
	
	class func get(chat:Chat ,useCache: Bool = false , completion: ((ChatResponse)->())? = nil , cacheType: ReadCacheType){
		if chat.createChatModel?.enableCache == true && useCache == true{
			switch cacheType {
				case .GET_CASHED_CONTACTS(_ :let req):
					let contacts = CMContact.getContacts(req: req)
					completion?(.init(result: nil, cacheResponse: contacts, error: nil))
					break
				case .GET_BLOCKED_USERS:
					//completion?(.init(result: nil, cacheResponse: CMBlocked.crud.getAll().map{$0.convertCMObjectToObject()}, error: nil))
					break
				case .GET_THREADS(_ : let req ):
					let threads = CMConversation.getThreads(req: req)
					completion?(.init(result: nil, cacheResponse: threads, error: nil))
					break
					
			}
		}
	}
	
	class func write(chat:Chat , cacheType: WriteCacheType){
		if chat.createChatModel?.enableCache == true{
			switch cacheType {
				case .CASHE_CONTACTS(contacts: let contacts):
					CMContact.insertOrUpdate(contacts: contacts)
					break
				case .GET_BLOCKED_USERS:
					break
				case .THREADS(_ : let threads):
					CMConversation.insertOrUpdate(conversations: threads)
					break
			}
		}
	}
}
