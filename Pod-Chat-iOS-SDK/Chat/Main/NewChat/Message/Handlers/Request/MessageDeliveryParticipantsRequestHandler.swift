//
//  MessageDeliveryParticipantsRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class MessageDeliveryParticipantsRequestHandler {
	
	class func handle( _ req:MessageDeliveredUsersRequest,
					   _ chat:Chat,
					   _ completion: @escaping CompletionType<[Participant]> ,
					   _ uniqueIdResult: UniqueIdResultType = nil
	){
		chat.prepareToSendAsync(req: req,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								messageType: .GET_MESSAGE_DELEVERY_PARTICIPANTS,
                                uniqueIdResult: uniqueIdResult){ response in
            completion(response.result as? [Participant] , response.error)
        }
	}
}
