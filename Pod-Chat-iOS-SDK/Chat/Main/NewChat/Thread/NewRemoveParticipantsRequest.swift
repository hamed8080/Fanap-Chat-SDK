//
//  NewRemoveParticipantsRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
public class NewRemoveParticipantsRequest : BaseRequest {
	
	public let participantId:  [Int]
	public let threadId:        Int
	
	public init(participantId:Int , threadId:Int) {
		self.threadId = threadId
		self.participantId = [participantId]
	}
	
	
	public init(participantIds:[Int] , threadId:Int) {
		self.threadId = threadId
		self.participantId = participantIds
	}
	
}
