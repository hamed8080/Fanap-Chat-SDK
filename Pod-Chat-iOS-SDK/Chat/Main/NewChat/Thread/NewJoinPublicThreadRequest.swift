//
//  NewJoinPublicThreadRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
public class NewJoinPublicThreadRequest: BaseRequest {
	
	public var threadName:String
	
	public init(threadName:String){
		self.threadName = threadName
	}
}
