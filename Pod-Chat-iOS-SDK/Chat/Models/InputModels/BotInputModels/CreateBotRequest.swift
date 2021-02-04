//
//  CreateBotRequest.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 2/5/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class CreateBotRequest {
    
    public let botName:      	String
    public let typeCode:    	String?
    public let uniqueId:    	String
    
    public init(botName:   String,
			  typeCode:   String? = nil,
			  uniqueId:   String? = nil) {
        
        self.botName    = botName
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
}
