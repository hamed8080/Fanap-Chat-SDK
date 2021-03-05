//
//  CloseThreadRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class CloseThreadRequestHandler {
	
	class func handle( _ req:NewCloseThreadRequest ,
					   _ chat:Chat,
					   _ completion: @escaping CompletionType<Int> ,
					   _ uniqueIdResult: ((String)->())? = nil
	){
		chat.prepareToSendAsync(req: nil,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.threadId,
								messageType: .CLOSE_THREAD,
                                uniqueIdResult: uniqueIdResult){ response in
            completion(response.result as? Int  , response.error)
        }
	}
}

	
