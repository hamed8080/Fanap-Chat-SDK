//
//  CurrentUserRolesRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
class CurrentUserRolesRequestHandler {
	
	class func handle( _ req:CurrentUserRolesRequest,
					   _ chat:Chat,
					   _ completion: @escaping CompletionType<[Roles]> ,
					   _ uniqueIdResult: UniqueIdResultType = nil
	){
		chat.prepareToSendAsync(req: nil,
								clientSpecificUniqueId: req.uniqueId,
								typeCode: req.typeCode ,
								subjectId: req.threadId,
								messageType: .GET_CURRENT_USER_ROLES,
                                uniqueIdResult: uniqueIdResult){ response in
            completion(response.result as? [Roles] , response.error)
        }
	}
}
