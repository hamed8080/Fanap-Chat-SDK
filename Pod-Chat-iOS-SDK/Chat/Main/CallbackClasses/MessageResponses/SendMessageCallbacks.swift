//
//  SendMessageCallbacks.swift
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
    
    /// SendMessage Response comes from server
    ///
    /// - Outputs:
    ///    - it doesn't have direct output,
    ///    - but on the situation where the response is valid,
    ///    - it will call the "onResultCallback" callback to sendMessage function (by using "sendCallbackToUserOnSent")
    func responseOfOnSendMessage(withMessage message: ChatMessage) {
        /**
         *
         *  -> check if we have saves the message uniqueId on the "mapOnSent" property
         *  -> if yes: (means we send this request and waiting for the response of it)
         *      -> check if Cache is enabled by the user
         *          -> if yes, save the income Data to the Cache
         *      -> call the "onSent" which will send callback to sendMessage function (by using "sendCallbackToUserOnSent")
         *
         */
        log.verbose("Message of type 'SENT' recieved", context: "Chat")
        
        let returnData = CreateReturnData(hasError:         false,
                                          errorMessage:     "",
                                          errorCode:        0,
                                          result:           nil,
                                          resultAsArray:    nil,
                                          resultAsString:   message.content,
                                          contentCount:     nil,
                                          subjectId:        message.subjectId)
        
        let myMessage = Message(threadId:       message.subjectId,
                                pushMessageVO:  message.content?.convertToJSON() ?? [:])
        let messageEventModel = MessageEventModel(type:     MessageEventTypes.MESSAGE_SEND,
                                                  message:  myMessage,
                                                  threadId: message.subjectId,
                                                  messageId: message.messageId,
                                                  senderId: nil,
                                                  pinned:   nil)
        delegate?.messageEvents(model: messageEventModel)
        
        if enableCache {
            if let _ = message.subjectId {
                // the response from server is come correctly, so this message will be removed from wait queue
                Chat.cacheDB.deleteWaitTextMessage(uniqueId: message.uniqueId)
                Chat.cacheDB.deleteWaitFileMessage(uniqueId: message.uniqueId)
                Chat.cacheDB.deleteWaitForwardMessage(uniqueId: message.uniqueId)
            }
        }
        
        if Chat.mapOnSent[message.uniqueId] != nil {
            let callback: CallbackProtocolWith3Calls = Chat.mapOnSent[message.uniqueId]!
            callback.onSent(uID:        message.uniqueId,
                            response:   returnData) { (successJSON) in
                self.sendCallbackToUserOnSent?(successJSON)
            }
            Chat.mapOnSent.removeValue(forKey: message.uniqueId)
        }
        
    }
    
    
    /// DeliveredMessage Response comes from server
    ///
    /// - Outputs:
    ///    - it doesn't have direct output,
    ///    - but on the situation where the response is valid,
    ///    - it will call the "onResultCallback" callback to sendMessage function (by using "sendCallbackToUserOnDeliver")
    func responseOfOnDeliveredMessage(withMessage message: ChatMessage) {
        /**
         *
         *  -> check if we have saves the message uniqueId on the "mapOnDeliver" property
         *  -> check if we can find the threadId inside the "mapOnDeliver" array
         *      -> yes:
         *          call the "onDeliver", which will send callback to sendMessage function (by using "sendCallbackToUserOnDeliver")
         *      -> no: it means that our request might be CreateThreadWithMessage that we didnt's have threadId befor
         *          call the "onDeliver", which will send callback to creatThreadWithMessage function (by using "sendCallbackToUserOnDeliver")
         *
         *  -> check the messages that are inside the mapOnDeliver threadId, and send mapOnDeliver for all of them that have been send befor this message
         *
         */
        log.verbose("Message of type 'DELIVERY' recieved", context: "Chat")
        
        let returnData = CreateReturnData(hasError:         false,
                                          errorMessage:     "",
                                          errorCode:        0,
                                          result:           nil,
                                          resultAsArray:    nil,
                                          resultAsString:   message.content,
                                          contentCount:     nil,
                                          subjectId:        message.subjectId)
        
        let myMessage = Message(threadId:         message.subjectId,
                                pushMessageVO:    message.content?.convertToJSON() ?? [:])
        let messageEventModel = MessageEventModel(type:     MessageEventTypes.MESSAGE_DELIVERY,
                                                  message:  myMessage,
                                                  threadId: message.subjectId,
                                                  messageId: message.content?.convertToJSON()["messageId"].int ?? message.messageId,
                                                  senderId: message.content?.convertToJSON()["participantId"].int ?? message.participantId,
                                                  pinned:   message.content?.convertToJSON()["pinned"].bool)
        delegate?.messageEvents(model: messageEventModel)
        
        var findItAt: Int?
        let threadIdObject = Chat.mapOnDeliver["\(message.subjectId ?? 0)"]
        if let threadIdObj = threadIdObject {
            
            for (index, item) in threadIdObj.enumerated() {
                let uniqueIdObj: [String: CallbackProtocolWith3Calls] = item
                if let callback = uniqueIdObj[message.uniqueId] {
                    findItAt = index
                    callback.onDeliver(uID:         message.uniqueId,
                                       response:    returnData) { (successJSON) in
                        self.sendCallbackToUserOnDeliver?(successJSON)
                    }
                }
            }
            
//            let threadIdObjCount = threadIdObj.count
//            if (threadIdObjCount > 0) {
//                for i in 1...threadIdObjCount {
//                    let uniqueIdObj: [String: CallbackProtocolWith3Calls] = threadIdObj[i - 1]
//                    if let callback = uniqueIdObj[message.uniqueId] {
//                        findItAt = i
//                        callback.onDeliver(uID:         message.uniqueId,
//                                           response:    returnData) { (successJSON) in
//                            self.sendCallbackToUserOnDeliver?(successJSON)
//                        }
//                    }
//                }
//            }
            
        } else {
            /**
             in situation that Create Thread with send Message, this part will execute,
             because at the beginnig of creating the thread, we don't have the ThreadID
             that we are creating,
             so all messages that sends by creating a thread simultanously, exeute from here:
             */
            let threadIdObject = Chat.mapOnDeliver["\(0)"]
            if let threadIdObj = threadIdObject {
                for (index, item) in threadIdObj.enumerated() {
                    if let callback = item[message.uniqueId] {
                        callback.onDeliver(uID:         message.uniqueId,
                                           response:    returnData) { (successJSON) in
                            self.sendCallbackToUserOnDeliver?(successJSON)
                        }
                        Chat.mapOnDeliver["\(0)"]?.remove(at: index)
                        break
                    }
                }
            }
        }
        
        if let itemAt = findItAt {
//            // unique ids that i have to send them that they delivery comes
//            var uniqueIdsWithDelivery: [String] = []
//
//            // find objects form first to index that delivery comes
//            for i in 1...itemAt {
//                if let threadIdObj = threadIdObject {
//                    let uniqueIdObj = threadIdObj[i - 1]
//                    for key in uniqueIdObj.keys {
//                        uniqueIdsWithDelivery.append(key)
//                    }
//                }
//            }
            
            // remove items from array and update array
            for _ in 0...itemAt {
                Chat.mapOnDeliver["\(message.subjectId ?? 0)"]?.removeFirst()
            }
//            for i in 0...(itemAt - 1) {
//                let index = i
//                Chat.mapOnDeliver["\(message.subjectId ?? 0)"]?.remove(at: index)
//            }
            
        }
        
    }
    
    
    /// SeenMessage Response comes from server
    ///
    /// - Outputs:
    ///    - it doesn't have direct output,
    ///    - but on the situation where the response is valid,
    ///    - it will call the "onResultCallback" callback to sendMessage function (by using "sendCallbackToUserOnSeen")
    func responseOfOnSeenMessage(withMessage message: ChatMessage) {
        /**
         *
         *  -> check if we have saves the message uniqueId on the "mapOnSeen" property
         *  -> check if we can find the threadId inside the "mapOnSeen" array
         *      -> yes:
         *          call the "onSeen", which will send callback to sendMessage function (by using "sendCallbackToUserOnSeen")
         *      -> no: it means that our request might be CreateThreadWithMessage that we didnt's have threadId befor
         *          call the "onSeen", which will send callback to creatThreadWithMessage function (by using "sendCallbackToUserOnSeen")
         *
         *  -> check the messages that are inside the mapOnSeen threadId, and send mapSeen for all of them that have been send befor this message
         *
         */
        log.verbose("Message of type 'SEEN' recieved", context: "Chat")
        
        if (message.content?.convertToJSON()["participantId"].int ?? message.participantId) == userInfo?.id {
            let messages = Chat.cacheDB.retrieveMessageHistory(count: 999,
                                                               firstMessageId: message.content?.convertToJSON()["messageId"].int ?? message.messageId,
                                                               fromTime: nil,
                                                               lastMessageId: nil,
                                                               messageId: nil,
                                                               messageType: nil,
                                                               offset: 0,
                                                               order: nil,
                                                               query: nil,
                                                               threadId: message.subjectId!,
                                                               toTime: nil,
                                                               uniqueIds: nil)
            Chat.cacheDB.updateUnreadCountOnCMConversation(withThreadId: message.subjectId!, unreadCount: messages?.history.count, addCount: nil)
        }
        
        let returnData = CreateReturnData(hasError:         false,
                                          errorMessage:     "",
                                          errorCode:        0,
                                          result:           nil,
                                          resultAsArray:    nil,
                                          resultAsString:   message.content,
                                          contentCount:     nil,
                                          subjectId:        message.subjectId)
        
        let myMessage = Message(threadId:         message.subjectId,
                                pushMessageVO:    message.content?.convertToJSON() ?? [:])
        let messageEventModel = MessageEventModel(type:     MessageEventTypes.MESSAGE_SEEN,
                                                  message:  myMessage,
                                                  threadId: message.subjectId,
                                                  messageId: message.content?.convertToJSON()["messageId"].int ?? message.messageId,
                                                  senderId: message.content?.convertToJSON()["participantId"].int ?? message.participantId,
                                                  pinned:   message.content?.convertToJSON()["pinned"].bool)
        delegate?.messageEvents(model: messageEventModel)
        
        var findItAt: Int?
        let threadIdObject = Chat.mapOnSeen["\(message.subjectId ?? 0)"]
        if let threadIdObj = threadIdObject {
            
            for (index, item) in threadIdObj.enumerated() {
                let uniqueIdObj: [String: CallbackProtocolWith3Calls] = item
                if let callback = uniqueIdObj[message.uniqueId] {
                    findItAt = index
                    callback.onSeen(uID:        message.uniqueId,
                                    response:   returnData) { (successJSON) in
                        self.sendCallbackToUserOnSeen?(successJSON)
                    }
                }
            }
            
//            if (threadIdObj.count > 0) {
//                for i in 1...threadIdObj.count {
//                    let index = i - 1
//                    let uniqueIdObj: [String: CallbackProtocolWith3Calls] = threadIdObj[index]
//                    if let callback = uniqueIdObj[message.uniqueId] {
//                        findItAt = i
//                        callback.onSeen(uID:        message.uniqueId,
//                                        response:   returnData) { (successJSON) in
//                            self.sendCallbackToUserOnSeen?(successJSON)
//                        }
//                    }
//                }
//            }
        } else {
            /**
             in situation that Create Thread with send Message, this part will execute,
             because at the beginnig of creating the thread, we don't have the ThreadId
             that we are creating,
             so callback of all messages that sends simultanously with creating a thread, exeute from here:
             */
            let threadIdObject = Chat.mapOnSeen["\(0)"]
            if let threadIdObj = threadIdObject {
                for (index, item) in threadIdObj.enumerated() {
                    if let callback = item[message.uniqueId] {
                        callback.onSeen(uID:        message.uniqueId,
                                        response:   returnData) { (successJSON) in
                            self.sendCallbackToUserOnSeen?(successJSON)
                        }
                        Chat.mapOnSeen["\(0)"]?.remove(at: index)
                        break
                    }
                }
            }
        }
        
        if let itemAt = findItAt {
//            // unique ids that i have to send them that they delivery comes
//            var uniqueIdsWithDelivery: [String] = []
//
//            // find objects form first to index that seen comes
//            for i in 1...itemAt {
//                if let threadIdObj = threadIdObject {
//                    let uniqueIdObj = threadIdObj[i - 1]
//                    for key in uniqueIdObj.keys {
//                        uniqueIdsWithDelivery.append(key)
//                    }
//                }
//            }
            
            // remove items from array and update array
//            var i = 0
//            while (i < itemAt + 1) {
//                Chat.mapOnSeen["\(message.subjectId ?? 0)"]?.removeFirst()
//            }
            for _ in 0...itemAt {
                Chat.mapOnSeen["\(message.subjectId ?? 0)"]?.removeFirst()
            }
//            for i in 1...itemAt {
//                Chat.mapOnSeen["\(message.subjectId ?? 0)"]?.remove(at: i - 1)
//            }
        }
        
    }
    
    
    public class SendMessageCallbacks: CallbackProtocolWith3Calls {
        var sendParams: SendChatMessageVO
        init(parameters: SendChatMessageVO) {
            self.sendParams = parameters
        }
        
        func onSent(uID:        String,
                    response:   CreateReturnData,
                    success:    @escaping callbackTypeAlias) {
            log.verbose("SendMessage Sent Callback", context: "Chat")
            if let stringContent = response.resultAsString {
                let message = SendMessageResponse(messageContent:   response.result,
                                                  messageId:        Int(stringContent) ?? 0,
                                                  isSent:           true,
                                                  isDelivered:      false,
                                                  isSeen:           false,
                                                  hasError:         response.hasError,
                                                  errorMessage:     response.errorMessage,
                                                  errorCode:        response.errorCode,
                                                  threadId:         response.subjectId,
                                                  participantId:    response.result?["participantId"].int)
                success(message)
            }
        }
        
        func onDeliver(uID:         String,
                       response:    CreateReturnData,
                       success:     @escaping callbackTypeAlias) {
            log.verbose("SendMessage Deliver Callback", context: "Chat")
            
            if let stringContent = response.resultAsString {
                let content = stringContent.convertToJSON()
                let message = SendMessageResponse(messageContent:   response.result,
                                                  messageId:        content["messageId"].int ?? 0,
                                                  isSent:           true,
                                                  isDelivered:      true,
                                                  isSeen:           false,
                                                  hasError:         response.hasError,
                                                  errorMessage:     response.errorMessage,
                                                  errorCode:        response.errorCode,
                                                  threadId:         content["conversationId"].int ?? response.subjectId,
                                                  participantId:    content["participantId"].int ?? 0)
                success(message)
            }
        }
        
        func onSeen(uID:        String,
                    response:   CreateReturnData,
                    success:    @escaping callbackTypeAlias) {
            log.verbose("SendMessage Seen Callback", context: "Chat")
            
            if let stringContent = response.resultAsString {
                let content = stringContent.convertToJSON()
                let message = SendMessageResponse(messageContent:   response.result,
                                                  messageId:        content["messageId"].int ?? 0,
                                                  isSent:           true,
                                                  isDelivered:      true,
                                                  isSeen:           true,
                                                  hasError:         response.hasError,
                                                  errorMessage:     response.errorMessage,
                                                  errorCode:        response.errorCode,
                                                  threadId:         content["conversationId"].int ?? response.subjectId,
                                                  participantId:    content["participantId"].int ?? 0)
                success(message)
            }
        }
        
    }
    
}
