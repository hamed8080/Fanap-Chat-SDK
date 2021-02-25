//
//  CreateBotRequest.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 2/5/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class CreateBotRequest : Encodable{
    
    public let botName:      	String
    
	@available(*,deprecated, message: "remove in future release. us erequest method")
	public let typeCode:    	String?
	@available(*,deprecated, message: "remove in future release. us erequest method")
    public let uniqueId:    	String
    
    public init(botName:   String,
			  typeCode:   String? = nil,
			  uniqueId:   String? = nil) {
        
        self.botName    = botName
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
	
	private enum CodingKeys : String , CodingKey{
		case botName = "botName"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(botName, forKey: .botName)
	}
    
}
