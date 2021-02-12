//
//  ContactNotSeenDurationRespoonse.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 10/30/1398 AP.
//  Copyright © 1398 Hamed Hosseini. All rights reserved.
//

open class ContactNotSeenDurationRespoonse: ResponseModel {
    
    public let notSeenDuration: [UserLastSeenDuration]
    
    public required init(notSeenDuration:    [UserLastSeenDuration],
                         hasError:           Bool,
                         errorMessage:       String,
                         errorCode:          Int) {
        self.notSeenDuration  = notSeenDuration
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

@available(*,unavailable , message: "use ContactNotSeenDurationRespoonse class")
open class GetContactNotSeenDurationResponse {}

