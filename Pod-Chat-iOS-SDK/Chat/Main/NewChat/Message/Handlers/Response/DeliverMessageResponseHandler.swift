//
//  DeliverMessageResponseHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/5/21.
//

import Foundation
class DeliverMessageResponseHandler: ResponseHandler {
    
    static func handle(_ chat: Chat, _ chatMessage: NewChatMessage, _ asyncMessage: AsyncMessage) {
        
//        let returnData = CreateReturnData(hasError:         false,
//                                          errorMessage:     "",
//                                          errorCode:        0,
//                                          result:           nil,
//                                          resultAsArray:    nil,
//                                          resultAsString:   message.content,
//                                          contentCount:     nil,
//                                          subjectId:        message.subjectId)
//        
//        let myMessage = Message(threadId:         message.subjectId,
//                                pushMessageVO:    message.content?.convertToJSON() ?? [:])
//        let messageEventModel = MessageEventModel(type:     MessageEventTypes.MESSAGE_DELIVERY,
//                                                  message:  myMessage,
//                                                  threadId: message.subjectId,
//                                                  messageId: message.content?.convertToJSON()["messageId"].int ?? message.messageId,
//                                                  senderId: message.content?.convertToJSON()["participantId"].int ?? message.participantId,
//                                                  pinned:   message.content?.convertToJSON()["pinned"].bool)
//        delegate?.messageEvents(model: messageEventModel)
//        
//        var findItAt: Int?
//        let threadIdObject = Chat.mapOnDeliver["\(message.subjectId ?? 0)"]
//        if let threadIdObj = threadIdObject {
//            
//            for (index, item) in threadIdObj.enumerated() {
//                let uniqueIdObj: [String: CallbackProtocolWith3Calls] = item
//                if let callback = uniqueIdObj[message.uniqueId] {
//                    findItAt = index
//                    callback.onDeliver(uID:         message.uniqueId,
//                                       response:    returnData) { (successJSON) in
//                        self.sendCallbackToUserOnDeliver?(successJSON)
//                    }
//                }
//            }
//            
//        } else {
//            /**
//             in situation that Create Thread with send Message, this part will execute,
//             because at the beginnig of creating the thread, we don't have the ThreadID
//             that we are creating,
//             so all messages that sends by creating a thread simultanously, exeute from here:
//             */
//            let threadIdObject = Chat.mapOnDeliver["\(0)"]
//            if let threadIdObj = threadIdObject {
//                for (index, item) in threadIdObj.enumerated() {
//                    if let callback = item[message.uniqueId] {
//                        callback.onDeliver(uID:         message.uniqueId,
//                                           response:    returnData) { (successJSON) in
//                            self.sendCallbackToUserOnDeliver?(successJSON)
//                        }
//                        Chat.mapOnDeliver["\(0)"]?.remove(at: index)
//                        break
//                    }
//                }
//            }
//        }
//        
//        if let itemAt = findItAt {
//            
//            // remove items from array and update array
//            for _ in 0...itemAt {
//                Chat.mapOnDeliver["\(message.subjectId ?? 0)"]?.removeFirst()
//            }
//        }
    }
    
}
