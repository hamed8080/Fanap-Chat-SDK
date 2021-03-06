//
//  CMMessage+extenstions.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation

extension CMMessage{
    
    public static let crud = CoreDataCrud<CMMessage>(entityName: "CMMessage")
    
    public func getCodable() -> Message{
		
		return Message(threadId:        threadId as? Int,
					   deletable:       deletable as? Bool,
					   delivered:       delivered as? Bool,
					   editable:        editable as? Bool,
					   edited:          edited as? Bool,
					   id:              id as? Int,
					   mentioned:       mentioned as? Bool,
					   message:         message,
					   messageType:     messageType as? Int,
					   metadata:        metadata,
					   ownerId:         ownerId as? Int,
					   pinned:          pinned as? Bool,
					   previousId:      previousId as? Int,
					   seen:            seen as? Bool,
					   systemMetadata:  systemMetadata,
					   time:            time as? UInt,
					   timeNanos:       0,
					   uniqueId:        uniqueId,
					   conversation:    conversation?.getCodable(),
					   forwardInfo:     forwardInfo?.getCodable(),
					   participant:     participant?.getCodable(),
					   replyInfo:       replyInfo?.getCodable())
    }
    
    public class func convertMesageToCM(message:Message ,entity:CMMessage? = nil) -> CMMessage{
		
        let model = entity ?? CMMessage()
		model.deletable                      = message.deletable as NSNumber?
		model.delivered                      = message.delivered as NSNumber?
		model.editable                       = message.editable as NSNumber?
		model.edited                         = message.edited as NSNumber?
		model.id                             = message.id as NSNumber?
		model.mentioned                      = message.mentioned as NSNumber?
		model.message                        = message.message
		model.messageType                    = message.messageType as NSNumber?
		model.metadata                       = message.metadata
		model.ownerId                        = message.ownerId as NSNumber?
		model.pinned                         = message.pinned as NSNumber?
		model.previousId                     = message.previousId as NSNumber?
		model.seen                           = message.seen as NSNumber?
		model.systemMetadata                 = message.systemMetadata
		model.threadId                       = message.threadId as NSNumber?
		model.time                           = message.time as NSNumber?
		model.uniqueId                       = message.uniqueId
//		model.conversation                   = message.conversation
//		model.dummyConversationLastMessageVO = message.dummyConversationLastMessageVO
//		model.forwardInfo                    = message.forwardInfo
//		model.participant                    = message.participant
//		model.replyInfo                      = message.replyInfo
        
        return model
    }
    
    public class func insertOrUpdate(message:Message , resultEntity:((CMMessage)->())? = nil){
        
		if let id = message.id, let findedEntity = CMMessage.crud.find(keyWithFromat: "coreUserId == %i", value: id){
            let cmMessage = convertMesageToCM(message: message, entity: findedEntity)
            resultEntity?(cmMessage)
        }else{
			CMMessage.crud.insert { cmMessage in
               let cmMessage = convertMesageToCM(message: message, entity: cmMessage)
                resultEntity?(cmMessage)
            }
        }
    }
}
