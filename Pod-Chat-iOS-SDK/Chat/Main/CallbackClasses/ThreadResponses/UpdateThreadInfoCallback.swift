//
//  UpdateThreadInfoCallback.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 3/18/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyBeaver
import FanapPodAsyncSDK


extension Chat {
    
    /// UpdateThreadInfo Response comes from server
    ///
    /// - Outputs:
    ///    - it doesn't have direct output,
    ///    - but on the situation where the response is valid,
    ///    - it will call the "onResultCallback" callback to updateThreadInfo function (by using "updateThreadInfoCallbackToUser")
    func responseOfUpdateThreadInfo(withMessage message: ChatMessage) {
        log.verbose("Message of type 'UPDATE_THREAD_INFO' recieved", context: "Chat")
        
        var threads: [Conversation]?
        if let content = message.content?.convertToJSON() {
            let thread = Conversation(messageContent: content)
            threads = [thread]
        }
        let tUpdateInfoEM = ThreadEventModel(type:          ThreadEventTypes.THREAD_INFO_UPDATED,
                                             participants:  nil,
                                             threads:       threads,
                                             threadId:      message.content?.convertToJSON()["id"].int ?? message.subjectId,
                                             senderId:      nil,
                                             unreadCount:   message.content?.convertToJSON()["unreadCount"].int,
                                             pinMessage:    nil)
        delegate?.threadEvents(model: tUpdateInfoEM)
        
        
        if enableCache {
            if let threadJSON = message.content?.convertToJSON() {
                let myThread = Conversation(messageContent: threadJSON)
                Chat.cacheDB.saveThread(withThreadObjects: [myThread])
            }
        }
        
        let returnData = CreateReturnData(hasError:         false,
                                          errorMessage:     "",
                                          errorCode:        0,
                                          result:           message.content?.convertToJSON(),
                                          resultAsArray:    nil,
                                          resultAsString:   nil,
                                          contentCount:     nil,
                                          subjectId:        message.subjectId)
        
        if Chat.map[message.uniqueId] != nil {
            let callback: CallbackProtocol = Chat.map[message.uniqueId]!
            callback.onResultCallback(uID:      message.uniqueId,
                                      response: returnData,
                                      success:  { (successJSON) in
                Chat.map.removeValue(forKey: message.uniqueId)
                self.updateThreadInfoCallbackToUser?(successJSON)
            }) { _ in }
            
        }
        
    }
    
    public class UpdateThreadInfoCallback: CallbackProtocol {
        func onResultCallback(uID:      String,
                              response: CreateReturnData,
                              success:  @escaping callbackTypeAlias,
                              failure:  @escaping callbackTypeAlias) {
            log.verbose("UpdateThreadInfoCallback", context: "Chat")
            
            if let content = response.result {
                let thread = Conversation(messageContent: content)
                let returnModel = GetThreadsResponse(conversationObjects:   [thread],
                                                     contentCount:          1,
                                                     count:                 1,
                                                     offset:                0,
                                                     hasError:              false,
                                                     errorMessage:          "",
                                                     errorCode:             0)
                success(returnModel)
//                if let threadId = content["id"].int {
//                    let getthreadRequestInput = GetThreadsRequestModel(count:               nil,
//                                                                       creatorCoreUserId:   nil,
//                                                                       metadataCriteria:    nil,
//                                                                       name:                nil,
//                                                                       new:                 nil,
//                                                                       offset:              nil,
//                                                                       partnerCoreContactId: nil,
//                                                                       partnerCoreUserId:   nil,
//                                                                       threadIds:           [threadId],
//                                                                       typeCode:            nil,
//                                                                       uniqueId:            uID)
//                    Chat.sharedInstance.getThreads(inputModel: getthreadRequestInput, getCacheResponse: nil, uniqueId: { (_) in }, completion: { (myResponse) in
//                        success(myResponse as! GetThreadsModel)
//                    }, cacheResponse: { (_) in })
//                }
            }
            
        }
        
    }
    
}
