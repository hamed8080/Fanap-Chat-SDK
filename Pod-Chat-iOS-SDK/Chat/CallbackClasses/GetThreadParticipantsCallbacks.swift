//
//  GetThreadParticipantsCallbacks.swift
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
    
    func responseOfThreadParticipants(withMessage message: ChatMessage) {
        /**
         *
         */
        log.verbose("Message of type 'THREAD_PARTICIPANTS' recieved", context: "Chat")
        
        let returnData = CreateReturnData(hasError:       false,
                                          errorMessage:   "",
                                          errorCode:      0,
                                          result:         nil,
                                          resultAsArray:  message.content?.convertToJSON().array,
                                          resultAsString: nil,
                                          contentCount:   message.contentCount,
                                          subjectId:      message.subjectId)
        
        if enableCache {
            var participants = [Participant]()
            var adminRequest = false
            for item in message.content?.convertToJSON() ?? [] {
                let myParticipant = Participant(messageContent: item.1, threadId: message.subjectId!)
                if ((myParticipant.roles?.count ?? 0) > 0) {
                    adminRequest = true
                }
                participants.append(myParticipant)
            }
            Chat.cacheDB.saveThreadParticipantObjects(whereThreadIdIs: message.subjectId!, withParticipants: participants, isAdminRequest: adminRequest)
        }
        
        if Chat.map[message.uniqueId] != nil {
            let callback: CallbackProtocol = Chat.map[message.uniqueId]!
            callback.onResultCallback(uID:      message.uniqueId,
                                      response: returnData,
                                      success:  { (successJSON) in
                self.threadParticipantsCallbackToUser?(successJSON)
            }) { _ in }
            Chat.map.removeValue(forKey: message.uniqueId)
        }
    }
    
    
    public class GetThreadParticipantsCallbacks: CallbackProtocol {
        var sendParams: SendChatMessageVO
        init(parameters: SendChatMessageVO) {
            self.sendParams = parameters
        }
        func onResultCallback(uID:      String,
                              response: CreateReturnData,
                              success:  @escaping callbackTypeAlias,
                              failure:  @escaping callbackTypeAlias) {
            /**
             *
             */
            log.verbose("GetThreadParticipantsCallbacks", context: "Chat")
            
            if let arrayContent = response.resultAsArray {
                let content = sendParams.content?.convertToJSON()
                let getThreadParticipantsModel = GetThreadParticipantsModel(messageContent: arrayContent,
                                                                            contentCount:   response.contentCount,
                                                                            count:          content?["count"].intValue ?? 0,
                                                                            offset:         content?["offset"].intValue ?? 0,
                                                                            hasError:       response.hasError,
                                                                            errorMessage:   response.errorMessage,
                                                                            errorCode:      response.errorCode)
                success(getThreadParticipantsModel)
            }
        }
    }
    
}
