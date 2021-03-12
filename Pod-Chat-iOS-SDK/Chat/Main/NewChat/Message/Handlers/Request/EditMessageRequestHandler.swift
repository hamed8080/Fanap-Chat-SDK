//
//  EditMessageRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/10/21.
//

import Foundation
class EditMessageRequestHandler {
    
    class func handle( _ req:NewEditMessageRequest,
                       _ chat:Chat,
                       _ completion:@escaping CompletionType<Message>,
                       _ uniqueIdResult: UniqueIdResultType = nil
    ){
        guard let token = chat.createChatModel?.token else {return}
        
        let sendChatMessageVO = NewSendChatMessageVO(chatMessageVOType:  ChatMessageVOTypes.EDIT_MESSAGE.intValue(),
                                                     token: token,
                                                     content:  req.textMessage.getCustomTextToSendWithRemoveSpaceAndEnter(),
                                                     messageType: req.messageType.rawValue,
                                                     metadata: req.metadata,
                                                     repliedTo: req.repliedTo,
                                                     subjectId: req.messageId,
                                                     typeCode:req.typeCode,
                                                     uniqueId: req.uniqueId,
                                                     isCreateThreadAndSendMessage: false)
        
        chat.prepareToSendAsync(sendChatMessageVO, uniqueId: req.uniqueId ?? UUID().uuidString){ response in
            completion(response.result as? Message , response.error)
        }
        CacheFactory.write(cacheType: .EDIT_MESSAGE_QUEUE(req))
        PSM.shared.save()
    }
}
