//
//  MentionsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class MentionsRequestHandler {
	
	class func handle( _ req:MentionRequest,
					   _ chat:Chat,
					   _ completion: @escaping CompletionType<[Message]> ,
                       _ cacheResponse: CacheResponseType<[Message]>? = nil,
					   _ uniqueIdResult: UniqueIdResultType = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.threadId,
								messageType: .GET_HISTORY,
                                uniqueIdResult: uniqueIdResult){ response in
            completion(response.result as? [Message] , response.error)
        }
        
        CacheFactory.get(useCache: cacheResponse != nil ,  cacheType: .MENTIONS){ response in
            cacheResponse?(response.cacheResponse as? [Message] , nil)
        }
	}
}
