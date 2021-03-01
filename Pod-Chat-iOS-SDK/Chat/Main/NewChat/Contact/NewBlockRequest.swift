//
//  NewBlockRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/1/21.
//

import Foundation

open class NewBlockRequest: Encodable {
	
	public let contactId:   Int?
	public let threadId:    Int?
	public let userId:      Int?
	
	
	public init(contactId: Int? = nil,
				threadId:   Int? = nil,
				userId:     Int? = nil) {
		self.contactId  = contactId
		self.threadId   = threadId
		self.userId     = userId
	}
	
}
