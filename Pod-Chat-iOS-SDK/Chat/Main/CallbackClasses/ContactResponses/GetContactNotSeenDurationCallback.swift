//
//  GetContactNotSeenDurationCallback.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 10/30/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation

import Foundation
import SwiftyBeaver
import FanapPodAsyncSDK
import SwiftyJSON


extension Chat {
    
    /// GetContactNotSeenDurationt Response comes from server
    ///
    /// - Outputs:
    ///    - it doesn't have direct output,
    ///    - but on the situation where the response is valid,
    ///    - it will call the "onResultCallback" callback to getContactNotSeenDuration function (by using "getContactNotSeenDurationCallbackToUser")
    func responseOfGetContactNotSeenDuration(withMessage message: ChatMessage) {
        log.verbose("Message of type 'GET_NOT_SEEN_DURATION' recieved", context: "Chat")
        
        let returnData = CreateReturnData(hasError:         false,
                                          errorMessage:     "",
                                          errorCode:        0,
                                          result:           message.content?.convertToJSON() ?? [:],
                                          resultAsArray:    nil,
                                          resultAsString:   nil,
                                          contentCount:     nil,
                                          subjectId:        nil)
        
        
        if Chat.map[message.uniqueId] != nil {
            let callback: CallbackProtocol = Chat.map[message.uniqueId]!
            callback.onResultCallback(uID:      message.uniqueId,
                                      response: returnData,
                                      success:  { (successJSON) in
                                        self.getContactNotSeenDurationCallbackToUser?(successJSON)
                                      }) { _ in }
            Chat.map.removeValue(forKey: message.uniqueId)
        }
    }
    
    public class GetContactNotSeenDurationCallback: CallbackProtocol {
        func onResultCallback(uID:      String,
                              response: CreateReturnData,
                              success:  @escaping callbackTypeAlias,
                              failure:  @escaping callbackTypeAlias) {
            log.verbose("NotSeenDurationCallback", context: "Chat")
            
            if !(response.hasError) {
                let notSeenDictionary = response.result?.dictionary?.mapValues{ $0.int }
                if let notSeens = notSeenDictionary?.map({ UserLastSeenDuration(userId: Int($0) ?? 0, time: $1 ?? 0)}){
                    let response = ContactNotSeenDurationRespoonse(notSeenDuration: notSeens,
                                                                   hasError: response.hasError,
                                                                   errorMessage: response.errorMessage,
                                                                   errorCode: response.errorCode)
                    success(response)
                }
            }
        }
    }
    
}
