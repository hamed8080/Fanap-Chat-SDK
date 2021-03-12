//
//  QueueOfEditMessages+extenstions.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation

extension QueueOfEditMessages{
    
    public static let crud = CoreDataCrud<QueueOfEditMessages>(entityName: "QueueOfEditMessages")
    
    public func getCodable() -> NewEditMessageRequest?{
        guard let threadId = threadId as? Int, let messageId = messageId as? Int , let textMessage = textMessage , let messageType  = messageType as? Int else {return nil}
        return NewEditMessageRequest(
            threadId:threadId,
            messageType: MessageType(rawValue: messageType) ?? .TEXT,
            messageId: messageId,
            textMessage: textMessage,
            repliedTo: repliedTo as? Int,
            metadata: metadata)
    }
    
    public class func convertToCM(request:NewEditMessageRequest ,entity:QueueOfEditMessages? = nil) -> QueueOfEditMessages{
        
        let model            = entity ?? QueueOfEditMessages()
        model.threadId       = request.threadId as NSNumber?
        model.messageId      = request.messageId as NSNumber?
        model.messageType    = request.messageType.rawValue as NSNumber?
        model.textMessage    = request.textMessage
        model.repliedTo      = request.repliedTo as NSNumber?
        model.typeCode       = request.typeCode
        model.uniqueId       = request.uniqueId
        model.metadata       = request.metadata
        
        return model
    }
    
    public class func insert(request:NewEditMessageRequest , resultEntity:((QueueOfEditMessages)->())? = nil){
        QueueOfEditMessages.crud.insert { cmEntity in
            let cmEntity = convertToCM(request: request , entity: cmEntity)
            resultEntity?(cmEntity)
        }
    }
    
}
