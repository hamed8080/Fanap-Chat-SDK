//
//  ThreadParticipantsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class ThreadParticipantsRequestHandler {
	
	class func handle( _ req:ThreadParticipantsRequest,
					   _ chat:Chat,
					   _ completion: @escaping CompletionType<[Participant]> ,
                       _ cacheResponse: CacheResponseType<[Participant]>? ,
					   _ uniqueIdResult:UniqueIdResultType = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.threadId,
								messageType: .THREAD_PARTICIPANTS,
                                uniqueIdResult: uniqueIdResult){ response in
            completion(response.result as? [Participant] , response.error)
        }
        
        CacheFactory.get(useCache: cacheResponse != nil , cacheType: .GET_THREAD_PARTICIPANTS(req)){ response in
            cacheResponse?(response.cacheResponse as? [Participant], nil)
        }
	}
}
