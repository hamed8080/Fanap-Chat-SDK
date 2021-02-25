//
//  StartStopBotRequest.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 2/5/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//

import SwiftyJSON
import Foundation

open class StartStopBotRequest: RequestModelDelegates , Encodable{
    
    public let botName:     String
    public let threadId:    Int
	
	@available(*,deprecated , message: "removed in future release.use in request method")
    public let typeCode:    String?
	@available(*,deprecated , message: "removed in future release.use in request method")
    public let uniqueId:    String
    
    public init(botName:    String,
                threadId:   Int,
                typeCode:   String? = nil,
                uniqueId:   String? = nil) {
        
        self.botName    = botName
        self.threadId   = threadId
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
    public func convertContentToJSON() -> JSON {
        var content: JSON = [:]
        content["botName"] = JSON(botName)
        return content
    }
    
    public func convertContentToJSONArray() -> [JSON] {
        return []
    }

	private enum CodingKeys : String , CodingKey{
		case botName  = "botName"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(botName, forKey: .botName)
	}
    
}
