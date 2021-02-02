//
//  AddParticipantsCallback.swift
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
    
    /// AddParticipant Response comes from server
    ///
    /// - Outputs:
    ///    - it doesn't have direct output,
    ///    - but on the situation where the response is valid,
    ///    - it will call the "onResultCallback" callback to addParticipant function (by using "addParticipantsCallbackToUser")
    func responseOfAddParticipant(withMessage message: ChatMessage) {
        guard let createChatModel = createChatModel else {return}
        log.verbose("Message of type 'ADD_PARTICIPANT' recieved", context: "Chat")
        
        if createChatModel.enableCache {
            var participants = [Participant]()
            if let res = message.content?.convertToJSON() {
                let conversation = Conversation(messageContent: res)
                for participant in conversation.participants ?? [] {
                    let myParticipant = Participant(messageContent: participant.formatToJSON(), threadId: message.subjectId)
                    participants.append(myParticipant)
                }
                Chat.cacheDB.saveThreadParticipantObjects(whereThreadIdIs: message.subjectId!, withParticipants: participants, isAdminRequest: false)
            }
        }
        
        let returnData = CreateReturnData(hasError:         false,
                                          errorMessage:     "",
                                          errorCode:        0,
                                          result:           message.content?.convertToJSON() ?? [:],
                                          resultAsArray:    nil,
                                          resultAsString:   nil,
                                          contentCount:     message.contentCount,
                                          subjectId:        message.subjectId)
        
        if Chat.map[message.uniqueId] != nil {
            let callback: CallbackProtocol = Chat.map[message.uniqueId]!
            callback.onResultCallback(uID: message.uniqueId, response: returnData, success: { (successJSON) in
                self.addParticipantsCallbackToUser?(successJSON)
            }) { _ in }
            Chat.map.removeValue(forKey: message.uniqueId)
        }
        
        let addParticipantModel = AddParticipantResponse(messageContent:    returnData.result ?? [:],
                                                         hasError:          false,
                                                         errorMessage:      "",
                                                         errorCode:         0)
        let tAddParticipantEM = ThreadEventModel(type:          ThreadEventTypes.THREAD_ADD_PARTICIPANTS,
                                                 participants:  addParticipantModel.thread?.participants,
                                                 threads:       nil,
                                                 threadId:      message.content?.convertToJSON()["id"].int ?? addParticipantModel.thread?.id ?? message.messageId,
                                                 senderId:      nil,
                                                 unreadCount:   message.content?.convertToJSON()["unreadCount"].int,
                                                 pinMessage:    nil)
        delegate?.threadEvents(model: tAddParticipantEM)
        let tLastActivityEM = ThreadEventModel(type:            ThreadEventTypes.THREAD_LAST_ACTIVITY_TIME,
                                               participants:    nil,
                                               threads:         nil,
                                               threadId:        message.content?.convertToJSON()["id"].int ?? addParticipantModel.thread?.id ?? message.messageId,
                                               senderId:        nil,
                                               unreadCount:     message.content?.convertToJSON()["unreadCount"].int,
                                               pinMessage:      nil)
        delegate?.threadEvents(model: tLastActivityEM)
        
    }
    
    
    public class AddParticipantsCallback: CallbackProtocol {
        var sendParams: SendChatMessageVO
        init(parameters: SendChatMessageVO) {
            self.sendParams = parameters
        }
        
        func onResultCallback(uID:      String,
                              response: CreateReturnData,
                              success:  @escaping callbackTypeAlias,
                              failure:  @escaping callbackTypeAlias) {
            log.verbose("AddParticipantsCallback", context: "Chat")
            
            if let content = response.result {
                let addParticipantModel = AddParticipantResponse(messageContent:    content,
                                                                 hasError:          response.hasError,
                                                                 errorMessage:      response.errorMessage,
                                                                 errorCode:         response.errorCode)
                success(addParticipantModel)
            }
        }
    }
    
}
