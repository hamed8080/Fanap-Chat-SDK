//
//  SendTextMessageRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/5/21.
//

import Foundation
class SendTextMessageRequestHandler {
    
    class func handle( _ req:NewSendTextMessageRequest,
                       _ chat:Chat,
                       _ onSent:  OnSentType ,
                       _ onSeen:  OnSeenType ,
                       _ onDeliver:  OnDeliveryType ,
                       _ uniqueIdResult: UniqueIdResultType = nil
    ){
        guard let token = chat.createChatModel?.token else {return}
        
        let sendChatMessageVO = NewSendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.MESSAGE.intValue(),
                                                     token: token,
                                                     content:  req.textMessage.getCustomTextToSendWithRemoveSpaceAndEnter(),
                                                     messageType: req.messageType.rawValue,
                                                     metadata: req.metadata,
                                                     repliedTo: req.repliedTo,
                                                     systemMetadata: req.systemMetadata,
                                                     subjectId: req.threadId,
                                                     typeCode:req.typeCode,
                                                     uniqueId: req.uniqueId,
                                                     isCreateThreadAndSendMessage: false)
        chat.prepareToSendAsync(sendChatMessageVO, uniqueId: req.uniqueId ?? UUID().uuidString, completion: nil,onSent: onSent , onDelivered: onDeliver, onSeen: onSeen)
        CacheFactory.write(cacheType: .SEND_TXET_MESSAGE_QUEUE(req))
        PSM.shared.save()
    }
}
