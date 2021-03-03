//
//  NewMuteUnmuteThreadRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation

public class NewMuteUnmuteThreadRequest : BaseRequest{
	
	public let threadId:   Int
	
	public init(threadId:  Int) {
		self.threadId  = threadId
	}
	
}
