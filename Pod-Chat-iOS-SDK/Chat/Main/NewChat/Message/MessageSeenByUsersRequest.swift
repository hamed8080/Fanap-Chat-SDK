//
//  MessageSeenByUsersRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/27/21.
//

import Foundation
public struct MessageSeenByUsersRequest : Encodable{
	
	let messageId:Int
	let offset:Int
	let count:Int
	
	public init (messageId:Int,count:Int = 50 , offset:Int = 0){
		self.messageId = messageId
		self.offset = offset
		self.count = count
	}
}
