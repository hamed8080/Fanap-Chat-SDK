//
//  AddBotCommandRequest.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 2/5/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//

import SwiftyJSON

open class AddBotCommandRequest: RequestModelDelegates , Encodable {
    
	public let botName			: String
	public var commandList		: [String] = []
	@available(*,deprecated , message: "removed in future release. use request method")
	public let typeCode		: String?
	@available(*,deprecated , message: "removed in future release. use request method")
	public let uniqueId		: String
    
    public init(botName:         String,
                commandList:    [String],
                typeCode:       String? = nil,
                uniqueId:       String? = nil) {
        
        self.botName    = botName
        for command in commandList {
            if (command.first == "/") {
                self.commandList.append(command)
            } else {
                self.commandList.append("/\(command)")
            }
        }
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
    public func convertContentToJSON() -> JSON {
        var content: JSON = [:]
        content["botName"]      = JSON(botName)
        content["commandList"]  = JSON(commandList)
        return content
    }
    
    public func convertContentToJSONArray() -> [JSON] {
        return []
    }
	
	private enum CodingKeys : String , CodingKey{
		case botName = "botName"
		case commandList = "commandList"
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(commandList, forKey: .commandList)
		try container.encode(botName, forKey: .botName)
	}
}
