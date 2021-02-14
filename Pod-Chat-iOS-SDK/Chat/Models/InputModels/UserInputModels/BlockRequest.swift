//
//  BlockRequest.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import SwiftyJSON

open class BlockRequest: Encodable {
    
    public let contactId:   Int?
    public let threadId:    Int?
    public let userId:      Int?
    
	@available(*,deprecated , message: "removed in future release. use typeCode In blockContact method params")
    public var typeCode:    String? = nil
	
	@available(*,deprecated , message: "removed in future release. use uniqueId inside blockContact method parameter.")
    public let uniqueId:    String
    
	@available(*,deprecated , message: "removed in future release use another init without uniqueId  and typeCode params")
    public init(contactId:  Int?,
                threadId:   Int?,
                userId:     Int?,
                typeCode:   String?,
                uniqueId:   String?) {
        
        self.contactId  = contactId
        self.threadId   = threadId
        self.userId     = userId
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
	
	public init(contactId: Int? = nil,
		 threadId:   Int? = nil,
		 userId:     Int? = nil) {
		self.contactId  = contactId
		self.threadId   = threadId
		self.userId     = userId
		self.uniqueId = UUID().uuidString
	}
    
	private enum CodingKeys : String , CodingKey{
		case contactId = "contactId"
		case threadId = "threadId"
		case userId = "userId"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encodeIfPresent(contactId, forKey: .contactId)
		try? container.encodeIfPresent(threadId, forKey: .threadId)
		try? container.encodeIfPresent(userId, forKey: .userId)
	}
    
}

@available(*,unavailable,message: "use BlockRequest class")
open class BlockContactsRequestModel: BlockRequest {}
