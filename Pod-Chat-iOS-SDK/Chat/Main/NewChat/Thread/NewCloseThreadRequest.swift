//
//  NewCloseThreadRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
public class NewCloseThreadRequest : BaseRequest {
	
	public var threadId:Int
	
	public init(threadId:Int){
		self.threadId = threadId
	}
}
