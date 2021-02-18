//
//  UnblockRequest.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import SwiftyJSON

open class UnblockRequest :Encodable{
	
    
    public let blockId:     Int?
    public let contactId:   Int?
    public let threadId:    Int?
    public let userId:      Int?
    
    public let typeCode:    String?
	@available(*,deprecated ,message: "removed in future release.")
    public let uniqueId:    String
    
    public init(blockId:    Int?,
                contactId:  Int?,
                threadId:   Int?,
                userId:     Int?,
                typeCode:   String?,
                uniqueId:   String?) {
        
        self.blockId    = blockId
        self.contactId  = contactId
        self.threadId   = threadId
        self.userId     = userId
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
	
	public init(blockId: Int? = nil,
				  contactId: Int? = nil,
				  threadId: Int? = nil,
				  userId: Int? = nil,
				  typeCode: String? = nil) {
		self.blockId = blockId
		self.contactId = contactId
		self.threadId = threadId
		self.userId = userId
		self.typeCode = typeCode
		
		//removed after remove property in this class
		self.uniqueId = UUID().uuidString
	}

    func convertContentToJSON() -> JSON {
        var content: JSON = [:]
        if let contactId = self.contactId {
            content["contactId"] = JSON(contactId)
        }
        if let threadId = self.threadId {
            content["threadId"] = JSON(threadId)
        }
        if let userId = self.userId {
            content["userId"] = JSON(userId)
        }
        
        return content
    }
    
	private enum CodingKeys :String , CodingKey{
		case contactId = "contactId"
		case threadId = "threadId"
		case userId = "userId"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(contactId, forKey: .contactId)
		try container.encodeIfPresent(threadId, forKey: .threadId)
		try container.encodeIfPresent(userId, forKey: .userId)
		
	}
}


@available(*, unavailable, message: "use UnblockRequest class")
open class UnblockContactsRequestModel: UnblockRequest {}

