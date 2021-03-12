//
//  GetHistoryRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/5/21.
//

import Foundation
class GetHistoryRequestHandler {
    
    class func handle( _ req:NewGetHistoryRequest,
                       _ chat:Chat,
                       _ completion: @escaping CompletionType<[Message]>,
                       _ cacheResponse: CompletionType<[Message]>? = nil,
                       _ textMessageNotSentRequests: CompletionType<[NewSendTextMessageRequest]>? = nil,
                       _ editMessageNotSentRequests: CompletionType<[NewEditMessageRequest]>? = nil,
                       _ forwardMessageNotSentRequests: CompletionType<[NewForwardMessageRequest]>? = nil,
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
        
        CacheFactory.get(useCache: cacheResponse != nil , cacheType: .GET_HISTORY(req)){ response in
            cacheResponse?(response.cacheResponse as? [Message] , nil)
        }
        
        CacheFactory.get(useCache: textMessageNotSentRequests != nil , cacheType: .GET_TEXT_NOT_SENT_REQUESTS(req.threadId)){ response in
            textMessageNotSentRequests?(response.cacheResponse as? [NewSendTextMessageRequest] , nil)
        }
        
        CacheFactory.get(useCache: editMessageNotSentRequests != nil , cacheType: .EDIT_MESSAGE_REQUESTS(req.threadId)){ response in
            editMessageNotSentRequests?(response.cacheResponse as? [NewEditMessageRequest] , nil)
        }
        
        CacheFactory.get(useCache: forwardMessageNotSentRequests != nil , cacheType: .FORWARD_MESSAGE_REQUESTS(req.threadId)){ response in
            forwardMessageNotSentRequests?(response.cacheResponse as? [NewForwardMessageRequest] , nil)
        }
        
    }
}
